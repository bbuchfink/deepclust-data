#!bin/bash

#seqs_to_align_part beinhaltet die FASTA-Dateinamen die aligner werden sollen, jackhmmer ruft die Datei dann auf



set -e

parallel -j 9 bash jackhmmer.sh {} :::: /ptmp/ebarbe/jackhmmer/seqs_to_align_part"$1"