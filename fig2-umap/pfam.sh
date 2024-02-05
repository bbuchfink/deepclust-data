#!/bin/bash

hmmscan --cpu 8 -E 0.001 -domE 0.001 --domtblout hmmer.txt -o /dev/null Pfam-A.hmm 1M.faa
grep -v '^#' hmmer.txt | tr -s ' ' '\t' | cut -f4,6,16,17 \
	| ../util/get-seq-cov.py | awk '{ if($2 >= 0.6) print }' > pfam.tsv
