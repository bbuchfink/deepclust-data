# Scripts to re-create DeepClust AlphaFold2 Analysis with random centroids:

DCD-Database:
- directory called joined_sort_clust_split
- contains 3786 files
- 3 Columns, Tab seperated: 1. Sequence ID; 2. Sequence; 3. Cluster ID
- sorted lexicographically, File name is first Cluster ID in this file. 

`search_seqs_to_ffformat.sh`:\
Takes a <mark>centroid</mark> name and a integer to infer tmp file.\
Searches for all sequences which are part of the cluster represented by the <mark>centroid</mark>. \
Further caluclates MSA for this cluster with FAMSA2.\
`run_random_search_seqs.sh`:\
Takes path to a file with list of centroids and integer to infer tmp file.\
Calls `search_seqs_to_ffformat.sh` and builds ffindex formated file for the clusters.

`rand_msa_evaluation.sh`:\
Counting Number of Sequences in MSAs created by AF2


Commands to create HMM-Profiles:\
Add hhconsensus to each cluster in ffindex file (can take really long): \
    /PATH_TO/ffindex_apply DCDB_msa.ff{data,index} -i DCDB_a3m.ffindex -d DCDB_a3m.ffdata -- /PATH_TO/hhconsensus -M 50 -maxseq 150000 -maxres 115535 -i stdin -oa3m stdout -v 0

Calculate HMM-Profiles for each cluster in ffindex file:\
    /PATH_TO/ffindex_apply DCDB_a3m.ffdata DCDB_a3m.ffindex -i DCDB_hhm.ffindex -d DCDB_hhm.ffdata -- /PATH_TO/hhmake -i stdin -o stdout -v 0

Call cstranslate to add pseudo counts:\
    /PATH_TO/cstranslate -f -x 0.3 -c 12 -I a3m -i DCDB_a3m -o DCDB_cs219

Combine two FFindex files with:\
    /PATH_TO/ffindex_build -s -a DCDB_1_a3m.ff{data,index} -d DCDB_2_a3m.ffdata -i ../random_corr/DCDB_2_a3m.ffindex

Sort Cluster by Size:\
    sort -k3 -n -r DCDB_cs219.ffindex | cut -f1 > sorting.dat

Reorder FFindex Database by `sorting.dat`:\
    /PATH_TO/ffindex_order sorting.dat /PATH_TO/DCDB_hhm.ff{data,index} /PATH_TO/DCDB_hhm_ordered.ff{data,index}\
    /PATH_TO/ffindex_order sorting.dat /PATH_TO/DCDB_a3m.ff{data,index} /PATH_TO/DCDB_a3m_ordered.ff{data,index}

Commands for Alignment Tools:

Jackhmmer query against Centroids:\
    /PATH_TO/jackhmmer --cpu 32 --tblout alignment.out -A alignment.sto --acc --noali --F1 0.0005 --F2 0.00005 --F3 0.0000005 --incE 0.0001 -E 0.0001 -N 1 sequence.fasta /path_to/centroids_smaller_than_100k.dedup.faa

Jackhmmer against Mgnify-Database to reduce expensive alignment runs:\
    /PATH_TO/jackhmmer --cpu 32 --tblout alignment.out --noali --notextw --incE 0.1 -E 0.1 sequence.fasta /PATH_TO/mgy_clusters_2022_05.fa

HHblits against BFD and Uniref30 to reduce expensive alignment runs (NOTE: a3m and tsv seem to report hits different, AF2 uses a3m):\
    /PATH_TO/hhblits -i sequence.fasta -cpu 18 -oa3m sequence.a3m -blasttab sequence.tsv -n 3 -e 0.001 -maxseq 1000000 -realign_max 100000 -maxfilt 100000 -min_prefilter_hits 1000 -d /PATH_TO/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt -d /PATH_TO/UniRef30_2021_03

Additional Information:
- AlphaFold2:
  - AF2 parameters:--run_msa_and_templates_only --nouse_gpu_relax
  - maximum template date set to 2022-12-31
- HHblits: set Parameter FFINDEX_MAX_ENTRY_NAME_LENGTH to 128 (in code)
