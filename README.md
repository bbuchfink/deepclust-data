Scripts to reproduce the results of Buchfink et al., "Sensitive clustering of protein sequences at tree-of-life scale using DIAMOND DeepClust".

# Data files

Data files that are required (see Data availability):

- `arch80_all.tsv`: File mapping NCBI accessions to Pfam domain architectures.
- `nr_accessions.tsv.zst`: List of all accessions in NR database that was used for the main benchmark.
- `reps_1M_ge5.tsv.zst`: List of accessions of randomly sampled representatives of the big ~19bn clustering run of clusters of size >= 5.
- `clan2acc.tsv`: File mapping Pfam accessions to clans.
- `reps_10k.ge2.faa`: Sequences of 10k randomly sampled representatives of the big ~19bn clustering run of clusters of size >= 2.
- `reps_10k.ge3.faa`: Sequences of 10k randomly sampled representatives of the big ~19bn clustering run of clusters of size >= 3.
- `clust.dedup2.tsv.zst`: TSV file mapping cluster member sequences to representatives for the big ~19bn clustering run.
- `centroids.dedup.faa`: FASTA file of representatives for the big ~19bn clustering run.
