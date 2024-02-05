#!/bin/bash

wget https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz
seqtk subseq nr.gz <(zstdcat ../nr_accessions.tsv.zst) > nr.faa
mmseqs createdb nr.faa nr
diamond makedb --in nr.faa -d nr --masking 0

seqtk sample nr.faa 270000000 > 270M.faa
seqtk sample nr.faa 135000000 > 135M.faa
seqtk sample nr.faa 68000000 > 68M.faa
seqtk sample nr.faa 55000000 > 55M.faa
seqtk sample nr.faa 27000000 > 27M.faa
seqtk sample nr.faa 10000000 > 10M.faa

mmseqs createdb 270M.faa 270M
mmseqs createdb 135M.faa 135M
mmseqs createdb 68M.faa 68M
mmseqs createdb 55M.faa 550M
mmseqs createdb 27M.faa 27M
mmseqs createdb 10M.faa 10M

diamond makedb --in 270M.faa -d 270M --masking 0
diamond makedb --in 135M.faa -d 135M --masking 0
diamond makedb --in 68M.faa -d 68M --masking 0
diamond makedb --in 55M.faa -d 55M --masking 0
diamond makedb --in 27M.faa -d 27M --masking 0
diamond makedb --in 10M.faa -d 10M --masking 0
