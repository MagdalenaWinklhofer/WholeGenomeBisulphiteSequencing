#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Methylpy_cc
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2


# load the needed modules
module load Anaconda3/2022.10
source ${EBROOTANACONDA3}/bin/activate
conda activate /cluster/projects/nn8014k/magdalena/conda_environments/methylpy_env
ml load  SAMtools/1.17-GCC-12.2.0
ml load Bowtie2/2.5.1-GCC-12.2.0

# show me the loaded modules in a list
ml list 

# it is good to have the following lines in any bash script
set -o errexit  # make bash exit on any error
set -o nounset  # treat unset variables as errors

# change directory to the program script 
cd /cluster/work/users/magdalena/11_DML/

# Commands for the program 
# NORMOXIA: allc_N1.tsv.gz,allc_N2.tsv.gz,allc_N3.tsv.gz,allc_N7.tsv.gz

methylpy merge-allc \
	--allc-files allc_N1.tsv.gz allc_N2.tsv.gz allc_N3.tsv.gz allc_N7.tsv.gz \
	--output-file allc_normoxia.tsv.gz \
	--num-procs 2 \
	--compress-output True





# to close everything 
ml purge 

