#!/bin/bash

mmseqs cluster annot out . --remove-tmp-files --threads 64 $?
mmseqs createtsv annot annot out out.tsv
clusteval clust .. out.tsv > eval.tsv
sens=`grep SENS eval.tsv | cut -f2,3 | ../util/convert-eval.py | ../util/avg.sh`
prec=`grep PREC eval.tsv | cut -f2,3 | ../util/convert-eval.py | ../util/avg.sh`
echo -e "$?\t$sens\t$prec"
rm out*
