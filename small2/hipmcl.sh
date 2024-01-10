#!/bin/bash
lastdb -p -P 32 lastdb_10M 10M.faa
lastal -P 32 -f BlastTab+ lastdb_10M 10M.faa | \
	sed '/^#/d' | \
	awk '{ if(($10-$9+1)/$14 >= 0.8 && ($8-$7+1)/$13 >= 0.8 && $3 >= 70) printf("%s\t%s\t%f\n", $1, $2, $12) }' \
	> last_aln.tsv

export OMP_NUM_THREADS=8
mpirun -np 4 hipmcl -M last_aln.tsv -I 2 -per-process-mem 32 -o hipmcl.out

cat hipmcl.out | ./convert-mcl.py > hipmcl.tsv
