#!/bin/bash -l
# Standard output and error:
#SBATCH -o ./job_hybrid.out.%j
#SBATCH -e ./job_hybrid.err.%j
# Initial working directory:
#SBATCH -D ./
# Job Name:
#SBATCH -J annot
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

query=$(printf "split/chunk%04d.fasta" "${SLURM_ARRAY_TASK_ID}")
db=$1
out="diamond_$1_${SLURM_ARRAY_TASK_ID}.tsv"

srun diamond blastp -q $query -d $db -o $out -k0 --ext full --ultra-sensitive -b2 --max-hsps 0 --algo 0 \
        -f 6 qseqid sseqid pident qstart qend qlen sstart send slen bitscore evalue