#!/bin/bash
CODE_DIR=$HOME
export PYSPARK_PYTHON=$(which python3)
export PYSPARK_DRIVER_PYTHON=$(which ipython3)

dir=$(pwd)
db=$dir/$1

cd $CODE_DIR/CODE/FLSH
python3 ./flsh.py \
        --num-mismatches 0 --num-hash-functions 0 -k 12 --full-pairs-mode False \
        --kmers-per-seq 80 --n-kmer-passes 1 \
	--pyspark-options "--driver-memory 1536G" \
        $db fasta $dir/out.tsv $dir/tmp1 $dir/tmp2 $dir/tmp3

cat $dir/out.tsv/*.csv > $dir/clust1
seqtk subseq $db <(cut -f1 $dir/clust1 | uniq) > $dir/centroids1.faa
$dir/../util/convertx.py centroids1.faa centroids1x.faa
#rm -rf $dir/tmp1
#rm -rf $dir/tmp2
#rm -rf $dir/tmp3

python3 ./flsh.py \
        --num-hash-functions 6 -k 12 --full-pairs-mode True --m-match 10 --num-mismatches 1 \
        --n-kmer-passes 1 \
	--pyspark-options "--driver-memory 1536G" \
        $dir/centroids1x.faa fasta $dir/out2.tsv $dir/tmp4 $dir/tmp5 $dir/tmp6

cat $dir/out2.tsv/*.csv > $dir/clust2
seqtk subseq $dir/centroids1x.faa <(cut -f1 $dir/clust2 | uniq) > $dir/centroids2.faa
#rm -rf $dir/tmp4
#rm -rf $dir/tmp5
#rm -rf $dir/tmp6

python3 ./flsh.py \
        --num-hash-functions 24 -k 12 --full-pairs-mode True --m-match 9 --num-mismatches 2 \
        --n-kmer-passes 1 \
	--pyspark-options "--driver-memory 1536G" \
        $dir/centroids2.faa fasta $dir/out3.tsv $dir/tmp7 $dir/tmp8 $dir/tmp9

cat $dir/out3.tsv/*.csv > $dir/clust3
$dir/../util/merge.sh $dir/clust2 $dir/clust3 > $dir/clust2_3
$dir/../util/merge.sh $dir/clust1 $dir/clust2_3 > $dir/clust1_2_3