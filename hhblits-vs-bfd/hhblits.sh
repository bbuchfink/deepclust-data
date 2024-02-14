#!/bin/bash

db=$1
out=$2
bfd=bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt
samtools faidx $db
N=$(wc -l $db.fai)

for i in {1..$N}; do
	acc=$(sed "$i!d" $db.fai | cut -f1)
	samtools faidx $db $acc > $i.faa
	hhblits -i $i.faa \
                -d $bfd -E 0.001 \
                -o $i.out -blasttab $i.tsv \
                -hide_pred -hide_dssp -cpu 16
done

cat *.tsv > all.tsv
../util/hhblits-get-cov.sh all.tsv $db.fai > covs
cut -f2 covs | sort -k1,1 -n -r | ../util/cum-dist.py 10000 > $out
