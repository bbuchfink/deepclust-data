/usr/bin/time mmseqs cluster nr out . -s 7.5 --max-seqs 250 -c 0.85 -e 0.1 --cluster-mode 1 --max-iterations 3
mmseqs createtsv nr nr out out.tsv
../util/get-eval.sh out.tsv mmseqs2
