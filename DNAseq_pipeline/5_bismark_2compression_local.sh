#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Methylpy_cc
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


# load the needed modules

# show me the loaded modules in a list
ml list 

# it is good to have the following lines in any bash script
set -o errexit  # make bash exit on any error
set -o nounset  # treat unset variables as errors

# change directory to the program script 
cd /cluster/work/users/magdalena/4_bismark_alignment_local_nondirectional

# Commands for the program
tar -czvf 4_bismark_alignment_local_nondirectional.tar .* | gzip -9 -cv > 4_bismark_alignment_local_nondirectional.tar.gz

# to close everything 
ml purge 


