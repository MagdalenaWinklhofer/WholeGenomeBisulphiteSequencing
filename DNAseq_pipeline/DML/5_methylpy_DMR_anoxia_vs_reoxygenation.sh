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

# anoxia vs reoxygenation 
methylpy DMRfind \
	--allc-files allc_A1.tsv.gz allc_A2.tsv.gz allc_A4.tsv.gz allc_A7.tsv.gz allc_24R2.tsv.gz allc_24R3.tsv.gz allc_24R7.tsv.gz allc_24R8.tsv.gz \
	--samples A1 A2 A4 A7 24R2 24R3 24R7 24R8\
	--sample-category 0 0 0 0 1 1 1 1 \
	--mc-type "CG" \
	--num-procs 2 \
	--output-prefix DMR_anoxia_vs_reoxygenation \


# anoxia vs reoxygenation merged 
#methylpy DMRfind \
#	--allc-files allc_anoxia.tsv.gz allc_reoxygenation.tsv.gz \
#	--samples anoxia reoxygenation \
#	--mc-type "CG" \
#	--num-procs 2 \
#	--output-prefix DMR_anoxia_vs_reoxygenation \


#methylpy DMRfind (old back up) \
#	--allc-files allc_A1.tsv.gz allc_24R3.tsv.gz \
#	--samples A1 24R3 \
#	--mc-type "CG" \
#	--num-procs 2 \
#	--output-prefix DMR \
	
# to close everything 
ml purge 

