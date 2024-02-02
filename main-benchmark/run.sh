#!/bin/bash

./diamond.sh
./diamond-lin.sh
./mmseqs.sh
./mmseqs-linclust.sh
/usr/bin/time ./flshclust.sh
