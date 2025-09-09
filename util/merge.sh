#!/bin/bash

outer=$1
inner=$2

export LC_ALL=C
join -1 1 -2 2 -t $'\t' -o 2.1,1.2 <(sort -k1,1 $outer) <(sort -k2,2 $inner) | sort -k1,1