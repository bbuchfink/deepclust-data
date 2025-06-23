#!/bin/bash

../util/clust-get-counts.sh <(zstdcat clust.dedup2.tsv.zst) | cut -f1 | sort -n -r > counts.tsv
cat counts.tsv | ../util/cum-dist.py 19387935704 > dist.tsv