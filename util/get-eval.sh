#!/bin/bash
clusteval clust .. $1 > eval.tsv
grep SENS eval.tsv | cut -f3,4 | ../util/convert-eval.py | gzip > $2.sens.gz
grep PREC eval.tsv | cut -f3,4 | ../util/convert-eval.py | gzip > $2.prec.gz
sens=`zcat $2.sens.gz | ../util/avg.sh`
prec=`zcat $2.prec.gz | ../util/avg.sh`
echo -e "$2\t$sens\t$prec"
