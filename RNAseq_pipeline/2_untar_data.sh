#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=UnTarData_cc
#SBATCH --time=24:00:00
#SBATCH --mem=12G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2


# load the needed modules
module purge 

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/RNA/

# Command of the program 
tar -xvf *.tar


# to close everything 
ml purge 