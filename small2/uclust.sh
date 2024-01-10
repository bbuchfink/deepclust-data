~/usearch -cluster_fast 10M.faa -id 0.0 -centroids uclust.faa  -uc clusters.uc \
	-query_cov 0.8 -target_cov 0.8 -threads 32
cut -f2,9 clusters.uc | cut -f1 -d' ' | sort -u | sort -k1,1 > uclust.tsv
