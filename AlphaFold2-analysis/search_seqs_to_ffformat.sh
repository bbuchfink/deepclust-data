#!/bin/bash
set -e

export LC_ALL=C

cent=$1
part=$2

#change paths to joined_sort_clust database and temporary cluster and MSA files
#change paths to FAMSA

for f_name in $(ls -r /ptmp/ebarbe/big_run/joined_sort_clust_split); do
	if [ "$cent" \> "$f_name" ]; then
		if [ $(grep -c -m 3 -w -F "$cent" /PATH/TO/joined_sort_clust_split/"$f_name") -eq 3 ]; then
			grep -w -F "$cent" /PATH/TO/joined_sort_clust_split/"$f_name" --no-group-separator | awk '{print $1,$2}' | sed 's/[*]//g' |sed 's/^/>/'|sed 's/ /\n/g' >> /PATH/TO/cluster_"$part"/"$cent"
			/PATH/TO//FAMSA/famsa -t 1 /PATH/TO/cluster_"$part"/"$cent" /PATH/TO/msa_"$part"/"$cent"
			rm PATH/TO/cluster_"$part"/"$cent"
		fi
		break ;
	fi
	if [ "$cent" = "$f_name" ]; then
		if [ $(grep -c -m 3 -w -F "$cent" /PATH/TO/joined_sort_clust_split/"$f_name") -eq 3 ]; then
			grep -w -F "$cent" /PATH/TO/joined_sort_clust_split/"$f_name" --no-group-separator | awk '{print $1,$2}' | sed 's/[*]//g' |sed 's/^/>/'|sed 's/ /\n/g' >> /PATH/TO/cluster_"$part"/"$cent"
			/PATH/TO//FAMSA/famsa -t 1 /PATH/TO/cluster_"$part"/"$cent" /PATH/TO/msa_"$part"/"$cent"
			rm PATH/TO/cluster_"$part"/"$cent"
		fi
		break ;
	fi
done
