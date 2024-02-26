from argparse import ArgumentParser
import locale
import pyarrow as pa
import pyarrow.csv as csv
import math
import os
import gc
import duckdb
import pyarrow.parquet as pq
import multiprocessing

locale.setlocale(locale.LC_ALL, 'C')

class DCD_clust:
    def __init__(self,range : list, ID: int):
        self.range = range
        self.ID = ID

class search_for_cluster:

    def __init__(self,path_to_DCD: str,path_to_centroids :str, path_to_output: str, path_to_index:str, per_clust_output : bool, threads : int,max_num_of_cluster_at_once : int, verbose : bool):
        self.path_to_DCD = path_to_DCD
        self.path_to_centroids = path_to_centroids
        #self.list_of_files = sorted(os.listdir(path_to_DCD))
        self.path_to_output = path_to_output
        self.path_to_index = path_to_index
        self.per_clust_output = per_clust_output
        self.threads = threads
        self.max_num_of_cluster_at_once = max_num_of_cluster_at_once
        self.verbose = verbose
        #self.clusters = os.read

        #self.cluster_list = {}
        #self.byte_offset = 0
        #self.index = {}
        self.nseqs = -1

    def dataRetrievalController(self, centroids: list, from_mmseqs : bool = False):
        locale.setlocale(locale.LC_ALL, 'C')
        pa.set_cpu_count(self.threads)
        all_centroids = []
        table = None
        #1. liste aller centroide:
        if(not from_mmseqs and len(self.path_to_centroids) > 0):
            table = pa.csv.read_csv(self.path_to_centroids,
                                read_options=csv.ReadOptions(autogenerate_column_names=True),
                                parse_options=csv.ParseOptions(delimiter=' ')).sort_by("f0")
            all_centroids = table[0].to_pylist()
        elif(len(self.path_to_centroids) > 0):
            table = pa.csv.read_csv(self.path_to_centroids,
                                read_options=csv.ReadOptions(autogenerate_column_names=True),
                                parse_options=csv.ParseOptions(delimiter='\t')).sort_by("f1")
            all_centroids = table[1].to_pylist()

        all_centroids.extend(centroids)
        all_cents_uniq = set(all_centroids)
        all_cents_sort = sorted(all_cents_uniq)
        del table,all_centroids
        gc.collect()
        curr = 0
        target_chunks = []
        if(self.max_num_of_cluster_at_once > 0):
            if self.verbose : print("Max Cluster: ", self.max_num_of_cluster_at_once)
            n_chunk = math.ceil(len(all_cents_sort) / self.max_num_of_cluster_at_once)
        else:
            n_chunk = 1

        index_time = 0
        cluster_time = 0
        parquet_file = pq.ParquetFile(self.path_to_DCD)
        if self.verbose : print("N-Chunk: ", n_chunk)
        for n in range(0,n_chunk):
            if (self.max_num_of_cluster_at_once > 0):
                end = min(((n +1) * self.max_num_of_cluster_at_once),len(all_cents_sort))
            else:
                end = len(all_cents_sort)
            targets = all_cents_sort[curr: end]
            if self.verbose : print("Part n: ", n+1, " for x Clusters: ", len(targets))
            if self.verbose : print("Curr: ", curr, " End: ", end)
            curr = end
            index,cluster_list = self.callIndexExtractionParallel(targets)
            self.startDataRetrievelParallel(index = index,cluster_list=cluster_list, parquet_file = parquet_file)
            del index, cluster_list
            gc.collect()

    def maintain_cluster_list(self, idx, cluster_list):
        #cent = str(idx[2]).replace('|', '_')
        cent = str(idx[2])
        cluster_list[cent] = DCD_clust(range(self.nseqs + 1, self.nseqs + int(idx[1]), 1),int(idx[0]))
        #self.cluster_list[cent] = DCD_cluster.DCD_clust(range(self.nseqs + 1, self.nseqs + idx[1], 1),idx[0])
        self.nseqs += int(idx[1])
        return cluster_list
        #return [*range(idx[0][0].as_py(),idx[0][0].as_py() + idx[1][0].as_py())]

    def callIndexExtractionParallel(self, targets : list, memory_limit : bool = True):

        path = os.path.dirname(os.path.join(self.path_to_index))
        if self.verbose : print("Path where persistent DuckDB Database is build: ", path)
        if not os.path.exists(path + "/persistent"):
            con = duckdb.connect(path + "/persistent")
            command = "CREATE TABLE clust_idx AS SELECT * FROM read_parquet('" + self.path_to_index + "')"
            con.sql(command)
            if self.verbose : print("Table created")
            con.sql("CREATE INDEX idx ON clust_idx (CLUSTER)")
            if self.verbose : print("Index created")
        else:
            con = duckdb.connect(path + "/persistent")
            if self.verbose : print("Using existing connection and table")
        con.execute(
            """CREATE OR REPLACE TABLE read_index (thread_name VARCHAR, insert_time TIMESTAMP DEFAULT current_timestamp)""")

        groups_per_cpu = math.ceil(len(targets) / self.threads)
        procs = []
        i = 1
        curr = 0
        manager = multiprocessing.Manager()
        index_list = manager.dict()
        cluster_list = manager.dict()

        for g in range(0, self.threads):
            end = min((i * groups_per_cpu), len(targets))
            targets_part = targets[curr:end]
            curr = curr + groups_per_cpu

            proc = multiprocessing.Process(target=self.getIndexFromParquet,
                                               args=(targets_part, index_list, str(i),cluster_list, con.cursor()))
            i += 1
            procs.append(proc)
            proc.start()

        for proc in procs:
            proc.join()
        con.close()

        return index_list,cluster_list

    def getIndexFromParquet(self, targets : list, index_list : dict, process : str,cluster_list, con):
        if self.verbose : print("Extracting Index From Parquet")
        parquet_file = None
        for t in targets:
            #target = t.replace('|', '_')
            command = "SELECT * FROM clust_idx WHERE CLUSTER = '" + t + "'"
            query = con.sql(command).fetchone()
            if(query):
                self.maintain_cluster_list(query,cluster_list)
                if self.verbose : print("Query: ", query)
                if str(query[3]) in index_list:
                    old = index_list[str(query[3])]
                    add = [*range(int(query[0]), int(query[0]) + int(query[1]))]
                    old.extend(add)
                    index_list[str(query[3])] = old
                else:
                    index_list[str(query[3])] = [*range(int(query[0]), int(query[0]) + int(query[1]))]
        return index_list

    def extractClusterFromParquet(self,index_keys,parquet_file,fasta_file, index, cluster_list):
        curr_clust = ''
        timeRowGroup = 0
        sizesRowGroup = 0
        timeExtractCluster = 0
        timeWriteToFile = 0
        memory_usage = 0
        for rowG in index_keys:
            text = ''
            rG = list(map(lambda i: int(i), rowG.split(sep=",")))
            mem_processed = 0
            for r in rG:

                table = parquet_file.read_row_group(r, columns=None, use_threads=False, use_pandas_metadata=False)

                mnn = parquet_file.metadata.row_group(r).column(3).statistics.min
                if (len(rG) > 1):
                    s = index[rowG][0]
                    m = len(index[rowG])
                    st = max(s - mnn, 0)
                    ed = min(st + (m - mem_processed), table.num_rows)
                    ran = [*range(st, ed)]
                    if(len(ran) > 0):
                        cluster = table.take(ran)
                    else:
                        break
                    mem_processed += (ed - st)
                else:
                    ran = [x - mnn for x in index[str(r)]]
                    cluster = table.take(ran)
                del table
                gc.collect()
                for batch in cluster.to_batches():
                    d = batch.to_pydict()
                    for c1, c2, c3 in zip(d['f0'], d['f1'], d['f2']):
                        text += '>' + str(cluster_list[c3].ID) + '_' + c1 + '\n' + c2 + '\n'
                        if (len(text) > 4389528):
                            fasta_file.write(bytes(text, encoding='utf8'))
                            text = ''
                del cluster
            fasta_file.write(bytes(text, encoding='utf8'))
            text = ''


        # stopping the library
        del index_keys
        gc.collect()
    def extractClusterFromParquetMultipleOutput(self,index_keys,parquet_file, index, cluster_list):
        #parquet_file = pq.ParquetFile(path_to_parquet)
        curr_cluster = ''
        first = True
        for rowG in index_keys:
            text = ''
            rG = list(map(lambda i: int(i), rowG.split(sep=",")))
            mem_processed = 0
            for r in rG:
                table = parquet_file.read_row_group(r, columns=None, use_threads=False, use_pandas_metadata=False)
                mnn = parquet_file.metadata.row_group(r).column(3).statistics.min
                if (len(rG) > 1):
                    s = index[rowG][0]
                    m = len(index[rowG])
                    st = max(s - mnn, 0)
                    ed = min(st + (m - mem_processed), table.num_rows)
                    ran = [*range(st, ed)]
                    if (len(ran) > 0):
                        cluster = table.take([*range(st, ed)])
                    else:
                        break
                    mem_processed += (ed - st)
                else:
                    ran = [x - mnn for x in index[str(r)]]
                    cluster = table.take(ran)
                for batch in cluster.to_batches():
                    d = batch.to_pydict()
                    for c1, c2, c3 in zip(d['f0'], d['f1'], d['f2']):
                        if curr_cluster != c3:
                            if first:
                                curr_cluster = c3
                                fasta_file = pa.OSFile(os.path.join(self.path_to_output + curr_cluster + '.fa'), 'wb')
                                first = False
                            else:
                                fasta_file.write(bytes(text, encoding='utf8'))
                                fasta_file.close()
                                curr_cluster = c3
                                text = ''
                                fasta_file = pa.OSFile(os.path.join(self.path_to_output + curr_cluster +'.fa'), 'wb')
                        text += '>' + c1 + '\n' + c2 + '\n'
                        if (len(text) > 4389528):
                        #if (len(text) > 1073741824):
                            fasta_file.write(bytes(text, encoding='utf8'))
                            text = ''
            fasta_file.write(bytes(text, encoding='utf8'))
            text = ''

    def startDataRetrievelParallel(self,index, cluster_list,parquet_file = None):
        if self.verbose : print("parallel cluster extraction on ", self.threads, " CPUs")
        idx_keys = list(index.keys())
        groups_per_cpu = math.ceil(len(idx_keys) / self.threads)
        procs = []
        fasta_files = []
        i=1
        curr=0
        if not parquet_file:
            parquet_file = pq.ParquetFile(self.path_to_DCD)
        for g in range(0,self.threads):
            end = min((i * groups_per_cpu), len(idx_keys))
            idx = idx_keys[curr:end]
            curr = curr + groups_per_cpu
            if self.per_clust_output:
                proc = multiprocessing.Process(target=self.extractClusterFromParquetMultipleOutput,
                                               args=(idx, parquet_file, index.copy(), cluster_list.copy()))
            else:
                if os.path.isfile(os.path.join(self.path_to_output + 'DCD_all_members_' + str(g) + '.fa')):
                    fasta_file = pa.OSFile(os.path.join(self.path_to_output + 'DCD_all_members_' + str(g) + '.fa'),
                                       'ab')
                    if self.verbose : print("Appending to " , fasta_file)
                else:
                    fasta_file = pa.OSFile(
                        os.path.join(self.path_to_output + 'DCD_all_members_' + str(g) + '.fa'),
                        'wb')
                fasta_files.append('DCD_all_members_'+ str(g) +'.fa')
                proc = multiprocessing.Process(target=self.extractClusterFromParquet,
                                               args=(idx,parquet_file,fasta_file, index.copy(),cluster_list.copy()))
            i += 1
            procs.append(proc)
            proc.start()

        # complete the processes
        for proc in procs:
            proc.join()

        with open(os.path.join(self.path_to_output + 'DCD_all_members.fa'), 'a') as outfile:
            for fname in fasta_files:
                with open(os.path.join(self.path_to_output + fname)) as infile:
                    for line in infile:
                        outfile.write(line)
                os.remove(self.path_to_output + fname)
        del index,cluster_list,idx_keys
        gc.collect()

def main():
    parser = ArgumentParser()
    parser.add_argument("--centroids",type = str, default="",
                        help="Comma separated list of centroids to extract")
    parser.add_argument("--centroid_file", type = str, default="",
                        help = "File with centroids to extract, one centroid per line")
    parser.add_argument("path_to_DCD", type=str,
                        help="Location of the DeepClust database in parquet format", )
    parser.add_argument("path_to_output", type = str,
                        help="Path to Output Directory")
    parser.add_argument("path_to_index", type=str, default="",
                        help = "Path to index in parquet format, DuckDB persistent Database will be created here")
    parser.add_argument("--per-clust-output",type = int, default=0,
                        help = "0: All Sequences are written to single FASTA file; 1: For each cluster a Fasta file is written.")
    parser.add_argument("--threads", type = int, default=1,
                        help = "Number of threads to use")
    parser.add_argument("--max_num_of_cluster_at_once", type=int, default=0,
                        help="Maximum number of cluster to extract at once, 0 means all; Default is 0")
    parser.add_argument("--verbose",type=int,default=0, help = "Print information")
    args = parser.parse_args()
    search = search_for_cluster(args.path_to_DCD,args.centroid_file, args.path_to_output, args.path_to_index, bool(args.per_clust_output), args.threads, args.max_num_of_cluster_at_once, bool(args.verbose))
    if args.verbose : print("Path To Index: ", search.path_to_index)
    print("Documentation, support and updates available at http://www.diamondsearch.org")
    print("Please cite: https://www.biorxiv.org/content/10.1101/2023.01.24.525373v1 bioRxiv (2023)")
    search.dataRetrievalController(args.centroids.split(sep = ","))






if __name__ == '__main__':
    main()