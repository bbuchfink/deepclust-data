Scripts for aligning the 1 million sample of representatives of clusters of size >= 3
against the BFD, CATH, ECOD, SCOP using HHblits (v3.3.0), against Uniprot and MGnify using DIAMOND (v2.1.14),
and against Pfam using HMMER (v3.4). Scripts to get the coverage per query from the alignment
output files and to plot the figure. `qlen.tsv` is a list of representative accessions and lengths.

HHblits databases for CATH, ECOD and SCOP can be downlodaded at the MPI Bioinformatics Toolkit Website:
http://ftp.tuebingen.mpg.de/pub/ebio/protevo/toolkit/databases/hhsuite_dbs/

Dependency: https://github.com/magnumripper/fcntl-lock