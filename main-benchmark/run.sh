#!/bin/bash

./diamond.sh nr.dmnd
./diamond-lin.sh nr.dmnd
./mmseqs.sh nr
./mmseqs-linclust.sh nr
/usr/bin/time ./flshclust.sh nr.faa

./diamond.sh 270M.dmnd
./diamond-lin.sh 270M.dmnd
./mmseqs.sh 270M
./mmseqs-linclust.sh 270M
/usr/bin/time ./flshclust.sh 270M.faa

./diamond.sh 135M.dmnd
./diamond-lin.sh 135M.dmnd
./mmseqs.sh 135M
./mmseqs-linclust.sh 135M
/usr/bin/time ./flshclust.sh 135M.faa

./diamond.sh 68M.dmnd
./diamond-lin.sh 68M.dmnd
./mmseqs.sh 68M
./mmseqs-linclust.sh 68M
/usr/bin/time ./flshclust.sh 68M.faa

./diamond.sh 55M.dmnd
./diamond-lin.sh 55M.dmnd
./mmseqs.sh 55M
./mmseqs-linclust.sh 55M
/usr/bin/time ./flshclust.sh 55M.faa

./diamond.sh 27M.dmnd
./diamond-lin.sh 27M.dmnd
./mmseqs.sh 27M
./mmseqs-linclust.sh 27M
/usr/bin/time ./flshclust.sh 27M.faa

./diamond.sh 10M.dmnd
./diamond-lin.sh 10M.dmnd
./mmseqs.sh 10M
./mmseqs-linclust.sh 10M
/usr/bin/time ./flshclust.sh 10M.faa

