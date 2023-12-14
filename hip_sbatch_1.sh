#!/bin/sh
#SBATCH -N 1 --exclusive
#SBATCH --ntasks-per-node=64
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out
#SBATCH --job-name=um.310_r1
#SBATCH --partition=standard


module load codes/gromacs-2022.2-intel
source /apps/compilers/intel/oneapi/setvars.sh

bash initial_configurations.sh
