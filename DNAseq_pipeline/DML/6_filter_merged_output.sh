#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Prefilter_cc
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=24G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


# load the needed modules
module load Anaconda3/2022.10
source ${EBROOTANACONDA3}/bin/activate
conda activate /cluster/projects/nn8014k/magdalena/conda_environments/general


# show me the loaded modules in a list
ml list 

# it is good to have the following lines in any bash script
set -o errexit  # make bash exit on any error
set -o nounset  # treat unset variables as errors

# change directory to the program script 
cd /cluster/work/users/magdalena/11_DML/res_merged/

python /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/DML/6_filter_merged_output.py

# Commands for the program 






	
# to close everything 
ml purge 

