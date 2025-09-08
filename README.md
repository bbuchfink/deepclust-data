Scripts to reproduce the results of Buchfink et al., "Sensitive clustering of protein sequences at tree-of-life scale using DIAMOND DeepClust".

# Data files

Data files that are required (see Data availability):

- `arch80_all.tsv`: File mapping NCBI accessions to Pfam domain architectures.
- `nr_accessions.tsv.zst`: List of all accessions in NR database that was used for the main benchmark.
- `clan2acc.tsv`: File mapping Pfam accessions to clans.
- `clust.dedup2.tsv.zst`: TSV file mapping cluster member sequences to representatives for the big ~19bn clustering run.
- `centroids.dedup.faa`: FASTA file of representatives for the big ~19bn clustering run.