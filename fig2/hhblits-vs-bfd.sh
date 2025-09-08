#!/bin/bash -l

run () {
        local queries=/ptmp/bbuchfink/diamond2022/big_run/reps_1M.ge3.faa
        local bfd=/ptmp/bbuchfink/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt
        local total=0
        local start=`date +%s`
        while :
        do
                local i=$(fcntl-lock -x $HOME/next ../util/fetch-add.sh)
                if [ "$i" -gt 1000000 ]
                        then return 0; fi
                local query=$(awk -F'\t' -v n=$i 'NR==n{print $1; exit}' $queries.fai)
                local end=`date +%s`
                local runtime=`expr $end - $start`
                echo "Query=$i Total=$total Time=$runtime Node=$SLURMD_NODENAME"
                samtools faidx $queries $query > queries/$i.faa
                hhblits -i queries/$i.faa \
                        -d $bfd -E 0.001 -v 0 \
                        -o hhblits_out/$i.out -blasttab hhblits_out/$i.tsv \
                        -hide_pred -hide_dssp -cpu 6
                rm queries/$i.faa
                echo $i >> finished
                total=$((total+1))
        done
}

module purge
module load gcc/14 openmpi/5.0 rocm/6.3
mkdir queries
mkdir hhblits_out
for i in {1..8}; do
        run &
done
wait