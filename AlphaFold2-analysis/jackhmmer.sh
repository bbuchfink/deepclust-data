#!bin/bash
set -e

seq=$1

${HOME}/hmmer/bin/jackhmmer --cpu 8 --tblout /ptmp/ebarbe/jackhmmer_output/$(basename $seq .fasta)_jack.out --noali --notextw --incE 0.1 -E 0.1 /ptmp/ebarbe/PDB_fasta/"$seq" /ptmp/ebarbe/big_run/centroids_smaller_than_100k.dedup.faa