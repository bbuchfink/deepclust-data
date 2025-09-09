#!/bin/bash

mmseqs cluster annot out . --remove-tmp-files --threads 64 "$@"
mmseqs createtsv annot annot out out.tsv
clusteval clust arch80_all.tsv out.tsv > out.eval
awk '{if($1=="SENS") print }' out.eval | cut -f3,4 | convert-eval.py | gzip > out.sens.gz
awk '{if($1=="PREC") print }' out.eval | cut -f3,4 | convert-eval.py | gzip > out.prec.gz
awk '{if($1=="SENS_CLAN") print }' out.eval | cut -f3,4 | convert-eval.py | gzip > out.sens_clan.gz