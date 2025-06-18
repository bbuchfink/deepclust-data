#!/bin/bash

set -e

list_of_centroids=$1

while IFS="" read -r p || [ -n "$p" ]
do
  bash ${HOME}/search_seqs_to_ffformat.sh "$p" $2 
done < "$list_of_centroids"

cd /PATH/TO/msa_"$part"/
/PATH/TO/ffindex_build -a -s /PATH/TO/HMM_Database/DCDB_part_"$2"_msa.ffdata /PATH/TO/HMM_Database/DCDB_part_"$2"_msa.ffindex .
cd ${HOME}
rm /PATH/TO/msa_"$part"/*
