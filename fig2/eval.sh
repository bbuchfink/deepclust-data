cut -f1,2,4,5 diamond_mgnify_* | ./cov.py /dev/stdin qlen.tsv > mgnify-covs.tsv
cut -f1,2,4,5 diamond_uniprot_* | ./cov.py /dev/stdin qlen.tsv > uniprot-covs.tsv
grep -h -v '^#' pfam_* | tr -s ' ' '\t' | awk '{ if($7 <= 0.001) printf("%s\t%s\t%s\t%s\n", $4, $1, $18, $19) }' \
        | ./cov-all-targets.py /dev/stdin qlen.tsv > pfam-covs.tsv
awk '{if ($11 <= 0.001) printf("%s\t%s\t%s\t%s\n", $1, $2, $7, $8) }' scop_aln.tsv \
        | ./cov-all-targets.py /dev/stdin qlen.tsv > scop-covs.tsv
awk '{if ($11 <= 0.001) printf("%s\t%s\t%s\t%s\n", $1, $2, $7, $8) }' ecod_aln.tsv \
	| ./cov-all-targets.py /dev/stdin qlen.tsv > ecod-covs.tsv
awk '{if ($11 <= 0.001) printf("%s\t%s\t%s\t%s\n", $1, $2, $7, $8) }' cath_aln.tsv \
    | ./cov-all-targets.py /dev/stdin qlen.tsv > cath-covs.tsv
awk '{if ($11 <= 0.001) printf("%s\t%s\t%s\t%s\n", $1, $2, $7, $8) }' bfd_aln.tsv \
    | ./cov.py /dev/stdin qlen.tsv > bfd-covs.tsv