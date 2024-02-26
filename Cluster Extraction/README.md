# Cluster Extraction for the DeepClust Database:
## General

The DeepClust Database is formatted into an [Apache Parquet](https://parquet.apache.org/) file.  
Parquet Files are structured into RowGroups where the data is stored column wise.
This allows extremely fast querying without the need to load the whole file into memory.
By limiting the RowGroup size of 169125 rows, the groups are small enough to fit into ~ 1GB of memory, allowing the data extraction on laptops.

The first step in the script is to determine where in the parquet file the Cluster is situated.
For this, an inedxed [DuckDB](https://duckdb.org/) Database is created. The indexed Database can either directly be downloaded or only a Parquet File version (smaller), then the Database is created during the run of the Script.
Then only the RowGroups found in the first step have to be loaded into memory and the clusters are extracted based on a row index.

Here is a benchmark done with an external SanDisk Extreme portable SSD with 4TB and 1GB I/O and an Intel Core i5-6500 CPU @ 3.2 GHz:

| Number of Clusters | Time in [s] | Number of sequences |
|--------------------|----------|---------------------|
| 1                  | 1        | 119                 |
| 100                | 5        | 7 391               |
| 1000               | 124      | 39 546              |
| 32000              | 2 608    | 1 649 332           |
| 100000             | 5 887    | 5 196 357           |

### References and helpfull links:
- [DuckDB](https://duckdb.org/) 
- [Apache Parquet](https://parquet.apache.org/)
- [Apache Arrow](https://arrow.apache.org/docs/index.html)
- [PyArrow](https://arrow.apache.org/docs/python/index.html) 
## Options:
[--centroids CENTROIDS]  
*Comma separated list of centroids to extract*  
Clusters are represented by centroid sequences. The script takes a comma separated list of centroids and extracts the corresponding member sequences.  
[--centroid_file PATH/TO/CENTROID_LIST]  
*File with centroids to extract, one centroid per line*  
The script also accepts a file where each line contains a centroid ID, both input modes can be combined.  
[path_to_DCD PATH/TO/DeepClustDatabase]  
*Location of the DeepClust database in parquet format*  
[path_to_output PATH/TO/OUTPUT/DIRECTORY]  
*Path to Output Directory*  
[path_to_index /PATH/TO/INDEX]  
*Path to index in parquet format, DuckDB persistent Database will be created here if not already existent.*   
[--per-clust-output INT]   
*0: All Sequences are written to a single FASTA file; 1: For each cluster a Fasta file is written.*   
[--threads INT]  
*Number of threads to use*   
[--max_num_of_cluster_at_once INT]   
*Maximum number of cluster to extract at once, 0 means all; Default is 0*   
[--verbose INT]   
*Print verbose outut*
