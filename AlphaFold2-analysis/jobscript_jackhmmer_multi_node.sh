#!/bin/bash -l
#SBATCH -J pdb_seqs
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=72
#SBATCH --mem=120000
#SBATCH --mail-type=none
#SBATCH --mail-user=emile.barbe@tuebingen.mpg.de
#SBATCH --time=24:00:00

set -e

module load parallel

parallel -N 1 -j 4 srun -N 1 -n 1 -c 72 bash jackhmmer_parallel_worker.sh {} ::: $(seq 1 4)