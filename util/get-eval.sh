#!/bin/bash
clusteval clust .. $1 > eval.tsv
grep SENS eval.tsv | cut -f3,4 | ../util/convert-eval.py > $2.sens.tsv
grep PREC eval.tsv | cut -f3,4 | ../util/convert-eval.py > $2.prec.tsv
sens=`cat $2.sens.tsv | ../util/avg.sh`
prec=`cat $2.prec.tsv | ../util/avg.sh`
echo -e "$2\t$sens\t$prec"
