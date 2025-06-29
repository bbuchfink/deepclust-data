#!/bin/bash -l
# Standard output and error:
#SBATCH -o ./job.out.%j
#SBATCH -e ./job.err.%j
# Initial working directory:
#SBATCH -D ./
# Job Name:
#SBATCH -J hhblits
#
# Number of nodes and MPI tasks per node:
#SBATCH --nodes=4
#
#SBATCH --mail-type=none
#SBATCH --mail-user=emile.barbe@tuebingen.mpg.de
#
# Wall clock limit (max. is 24 hours):
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --mem=120000
#--ntasks-per-node=1
#SBATCH --cpus-per-task=72

# Run the program:

module load parallel

parallel -N 1 -j 4 srun bash hhblits.sh {} ::: $(seq 1 4)