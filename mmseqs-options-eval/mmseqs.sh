#!/bin/bash

mmseqs cluster annot out . --remove-tmp-files --threads 64 "$@"
mmseqs createtsv annot annot out out.tsv
../util/get-eval.sh out.tsv "$@"
rm out*
