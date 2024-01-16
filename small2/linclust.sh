mmseqs createdb 10M.faa mmseqs_10M
mmseqs linclust mmseqs_10M out . -c 0.8 --cluster-mode 1  --max-iterations 3 --cov-mode 0 --min-seq-id 0 \
        --kmer-per-seq 80
mmseqs createtsv mmseqs_10M mmseqs_10M out out.tsv
