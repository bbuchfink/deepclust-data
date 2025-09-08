#!/bin/bash -l
# Standard output and error:
#SBATCH -o ./job_hybrid.out.%j
#SBATCH -e ./job_hybrid.err.%j
# Initial working directory:
#SBATCH -D ./
# Job Name:
#SBATCH -J hmmer
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

for ((i=$1; i<=$2; i++)); do
        echo $i
        query=$(printf "split/chunk%04d.fasta" "$i")
        echo $query
        hmmscan --cpu 8 -E 0.001 --domE 0.001 --domtblout pfam_$i.txt -o /dev/null Pfam-A.hmm $query &
done

wait