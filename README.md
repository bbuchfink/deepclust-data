Scripts to reproduce the results of Buchfink et al., "Sensitive clustering of protein sequences at tree-of-life scale using DIAMOND DeepClust", bioRxiv 2023.

# Data files

Data files can be downloaded at ... and should be placed in the root of the repository.

- `arch80_all.tsv`: File mapping NCBI accessions to Pfam domain architectures.
- `nr_accessions.tsv.zst`: List of all accessions in NR database that was used for the main benchmark.
- `reps_1M_ge5.tsv.zst`: List of accessions of randomly samples representatives of the big ~19bn clustering run of clusters of size >= 5.
- `arch80_10M.tsv`: File mapping NCBI accessions to Pfam domain architectures (for small database benchmark of 10M sequences).
- `clan2acc.tsv`: File mapping Pfam accessions to clans.
- `accessions_10M.tsv.zst`: List of accessions in 10M sequences file used for the small database benchmark. 
- `reps_10k.ge2.faa`: Sequences of 10k randomly samples representatives of the big ~19bn clustering run of clusters of size >= 2.
- `reps_10k.ge3.faa`: Sequences of 10k randomly samples representatives of the big ~19bn clustering run of clusters of size >= 3.
