/usr/bin/time mmseqs linclust $1 out . -c 0.8 --cluster-mode 1 --max-iterations 3 --cov-mode 0 --min-seq-id 0 --kmer-per-seq 80
mmseqs createtsv $1 $1 out out.tsv
../util/get-eval.sh out.tsv linclust