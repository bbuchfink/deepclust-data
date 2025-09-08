/usr/bin/time mmseqs cluster $1 out . -s 7.5 --max-seqs 250 -c 0.85 -e 0.1 --cluster-mode 1 --max-iterations 3
mmseqs createtsv $1 $1 out out.tsv