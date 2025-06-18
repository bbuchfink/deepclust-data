#!/bin/bash
# Standard output and error:
#SBATCH -o ./%j.log
#SBATCH -e ./%j.log
# Initial working directory:
#SBATCH -D ./
# Job Name:
#SBATCH -J diamond
#
# Number of nodes and MPI tasks per node
#SBATCH --nodes=32
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=256
#SBATCH --ntasks-per-core=2
#
# Wall clock limit (max. is 24 hours):
#SBATCH --time=02:00:00

db=$(pwd)/db.tsv

srun diamond linclust -d $db --log -M 500G --parallel-tmpdir $(pwd)/tmp/ --linclust-chunk-size 100G --approx-id 90