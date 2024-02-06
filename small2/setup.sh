#!/bin/bash

wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
seqtk subseq nr.gz <(zstdcat ../accessions_10M.tsv.zst) > 10M.faa
