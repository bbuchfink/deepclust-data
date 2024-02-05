cat astral-scopedom-seqres-gd-sel-gs-bib-95-2.08.faastral-scopedom-seqres-gd-sel-gs-bib-95-2.08.fa \
	ecod.latest.F70.fasta.txt \
	cath-domain-seqs-S95-v4_3_0.fa > astral.fa
diamond makedb --in astral.fa -d astral
diamond blastp -q 1M.faa -d astral -o out.tsv --ultra-sensitive -f 6 qseqid qlen qstart qend
cat out.tsv | ../util/get-seq-cov.py | awk '{ if($2 >= 0.6) print }'
