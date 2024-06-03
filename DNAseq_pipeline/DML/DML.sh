#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=DML_cc
#SBATCH --time=05:00:00
#SBATCH --mem-per-cpu=64G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

# load the needed modules
ml load 

# show me the loaded modules in a list
ml load R/4.2.2-foss-2022b
ml load R-bundle-Bioconductor/3.16-foss-2022b-R-4.2.2

# it is good to have the following lines in any bash script
set -o errexit  # make bash exit on any error
set -o nounset  # treat unset variables as errors

# change directory to the program script 
cd /cluster/projects/nn8014k/magdalena/script_WGBS/DML/

# Commands for the program (alignment of the reads to the genome)
Rscript DML.R > DML_out.Rout


# to close everything 
ml purge 











