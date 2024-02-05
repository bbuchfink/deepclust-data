#!/bin/bash

diamond blastp -q 1M.faa -d uniref100.fa -o uniprot.tsv --query-cover 90 --approx-id 30 -f 6 qseqid -k1
