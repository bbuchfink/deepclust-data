#!/bin/bash
clusteval clust .. $1 > eval.tsv
sens=`grep SENS eval.tsv | cut -f3,4 | ../util/convert-eval.py | ../util/avg.sh`
prec=`grep PREC eval.tsv | cut -f3,4 | ../util/convert-eval.py | ../util/avg.sh`
echo -e "$2\t$sens\t$prec"
