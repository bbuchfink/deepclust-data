#!/bin/bash

wget https://bfd.mmseqs.com/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt.tar.gz
tar xzf bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt.tar.gz

./hhblits.sh ../reps_10k.ge2.faa reps_10k.ge2.tsv
./hhblits.sh ../reps_10k.ge3.faa reps_10k_ge3.tsv
