#!/bin/bash
clusteval clust arch80_all.tsv $1.tsv > $1.eval
awk '{if($1=="SENS") print }' $1.eval | cut -f3,4 | convert-eval.py | gzip > $1.sens.gz
awk '{if($1=="PREC") print }' $1.eval | cut -f3,4 | convert-eval.py | gzip > $1.prec.gz
awk '{if($1=="SENS_CLAN") print }' $1.eval | cut -f3,4 | convert-eval.py | gzip > $1.sens_clan.gz