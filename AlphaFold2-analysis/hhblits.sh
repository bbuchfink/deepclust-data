#!bin/bash
set -e

parallel -j 9 ${HOME}/hhsuite/bin/hhblits -i /ptmp/ebarbe/PDB_fasta/{} -d /raven/ri/public_sequence_data/alphafold2/git-v2.3.1/data/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt -e 0.1 -o /ptmp/ebarbe/hhblit_bfd/{}.out -blasttab /ptmp/ebarbe/hhblit_bfd/{}.tsv -hide_pred  -hide_dssp -cpu 8 :::: /ptmp/ebarbe/hhblits/seqs_to_align_part"$1"