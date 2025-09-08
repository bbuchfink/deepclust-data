#!/bin/bash -l
# Standard output and error:
#SBATCH -o ./job_hybrid.out.%j
#SBATCH -e ./job_hybrid.err.%j
# Initial working directory:
#SBATCH -D ./
# Job Name:
#SBATCH -J hhblits
#
# Number of nodes and MPI tasks per node:
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
# Enable SMT:
#SBATCH --ntasks-per-core=2
# for OpenMP:
#SBATCH --cpus-per-task=256
#
#SBATCH --mail-type=none
#SBATCH --mail-user=userid@example.mpg.de
#
# Wall clock Limit (max. is 24 hours):
#SBATCH --time=24:00:00

module purge
module load gcc/14

run() {
for ((i=$1; i<=$2; i++)); do
        local queries=/ptmp/bbuchfink/diamond2022/big_run/reps_1M.ge3.faa
        local query=$(awk -F'\t' -v n=$i 'NR==n{print $1; exit}' $queries.fai)
        samtools faidx $queries $query > queries/$i.faa
        hhblits -i queries/$i.faa \
                -d db/ECOD/ECOD_F70_20220613 -E 0.001 -v 0 \
                -o ecod/$i.out -blasttab ecod/$i.tsv \
                -hide_pred -hide_dssp -cpu 2
        hhblits -i queries/$i.faa \
                -d db/CATH/CATH_S40 -E 0.001 -v 0 \
                -o cath/$i.out -blasttab cath/$i.tsv \
                -hide_pred -hide_dssp -cpu 2
        hhblits -i queries/$i.faa \
                -d db/scope70/scope70 -E 0.001 -v 0 \
                -o scop/$i.out -blasttab scop/$i.tsv \
                -hide_pred -hide_dssp -cpu 2
        rm queries/$i.faa
done
}

for i in {0..127}; do
        start=$((7813*i+1))
        end=$((7813*(i+1)))
        run $start $end &
done

wait