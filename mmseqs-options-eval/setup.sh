#!/bin/bash

wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
seqtk subseq nr.gz <(cut -f1 ../arch80_all.tsv) > annot.faa
mmseqs createdb annot.faa annot
