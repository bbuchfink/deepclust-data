#!/bin/bash

tar xzf bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt.tar.gz
grep -a -A 1 "consensus" bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt_a3m.ffdata \
	--no-group-separator > bfd.faa
gunzip mgy_clusters.fa.gz

diamond makedb --in <(cat bfd.faa mgy_clusters.fa) -d bfd --masking 0
diamond blastp -q 1M.faa -d bfd.dmnd -o bfd.tsv --query-cover 90 --approx-id 30 -f 6 qseqid -k1 --ultra-sensitive -c1
