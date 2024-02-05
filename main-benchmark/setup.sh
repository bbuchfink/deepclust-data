#!/bin/bash

wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
seqtk subseq nr.gz <(zstdcat ../nr_accessions.tsv.zst) > nr.faa
mmseqs createdb nr.faa nr
diamond makedb --in nr.faa -d nr --masking 0
