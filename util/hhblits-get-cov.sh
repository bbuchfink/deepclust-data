#!/bin/bash

export LC_ALL=C
join -t$'\t' <(sort.sh -k1,1 $1) <(cut -f1,2 $2 | sort.sh -k1,1) | \
        awk '{ printf("%s\t%f\n", $1, ($8-$7+1)/$13) }' |
        awk 'BEGIN { query=""; max_cov=0.0 } { if(query != $1) { printf("%s\t%f\n", query, max_cov); query=$1; max_cov=0.0 }; if($2 > max_cov) max_cov=$2 }'
