mmseqs createdb 10M.faa mmseqs_db
mmseqs cluster mmseqs_db mmseqs_out . -s 7.5 --max-seqs 250 -c 0.85 -e 0.1 --cluster-mode 1 --max-iterations 3
mmseqs createtsv mmseqs_db mmseqs_db mmseqs_out mmseqs_out.tsv
