#!/bin/bash
/usr/bin/time cd-hit -i 10M.faa -o out.clstr -M 128000 -d 0 -T 32 -G 0 \
        -n 4 -aL 0.8 -aS 0.8 -c 0.6
cat out.clstr | ./convert-cdhit.py > out.tsv
../util/get-eval-small.sh out.tsv cdhit-n4

/usr/bin/time cd-hit -i 10M.faa -o out.clstr -M 128000 -d 0 -T 32 -G 0 \
        -n 5 -aL 0.8 -aS 0.8 -c 0.7
cat out.clstr | ./convert-cdhit.py > out.tsv
../util/get-eval-small.sh out.tsv cdhit-n5

