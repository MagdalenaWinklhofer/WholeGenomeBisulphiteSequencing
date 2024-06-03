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
#DMR
# NORMOXIA: allc_N1.tsv.gz,allc_N2.tsv.gz,allc_N3.tsv.gz,allc_N7.tsv.gz
# ANOXIA: allc_A1.tsv.gz,allc_A2.tsv.gz,allc_A4.tsv.gz,allc_A7.tsv.gz
# REOXYGENATION: allc_24R2.tsv.gz,allc_24R3.tsv.gz,allc_24R7.tsv.gz,allc_24R8.tsv.gz

# noroxia vs anoxia
methylpy DMRfind \
	--allc-files allc_N1.tsv.gz allc_N2.tsv.gz allc_N3.tsv.gz allc_N7.tsv.gz allc_A1.tsv.gz allc_A2.tsv.gz allc_A4.tsv.gz allc_A7.tsv.gz \
	--samples N1 N2 N3 N7 A1 A2 A4 A7 \
	--sample-category 0 0 0 0 1 1 1 1 \
	--mc-type "CG" \
	--num-procs 2 \
	--output-prefix DMR_normoxia_vs_anoxia \

#methylpy DMRfind (old back up) \
#	--allc-files allc_A1.tsv.gz allc_24R3.tsv.gz \
#	--samples A1 24R3 \
#	--mc-type "CG" \
#	--num-procs 2 \
#	--output-prefix DMR \

# noroxia vs anoxia merged
#methylpy DMRfind \
#	--allc-files allc_normoxia.tsv.gz allc_anoxia.tsv.gz \
#	--samples normoxia anoxia \
#	--mc-type "CG" \
#	--num-procs 2 \
#	--output-prefix DMR_normxia_vs_anoxia \
	
# to close everything 
ml purge 

