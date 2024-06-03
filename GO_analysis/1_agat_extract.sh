#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Agat_cc
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


# load the Anaconda3
module load Anaconda3/2022.10

################## conda in SAGA ########################
# Set the ${PS1} (needed in the source of the Anaconda environment)
export PS1=\$
# Source the conda environment setup
# The variable ${EBROOTANACONDA3} or ${EBROOTMINICONDA3}
# So use one of the following lines
# comes with the module load command
# source ${EBROOTMINICONDA3}/etc/profile.d/conda.sh
source ${EBROOTANACONDA3}/etc/profile.d/conda.sh
 

# Deactivate any spill-over environment from the login node
conda deactivate &>/dev/null

# Activate the environment by using the full path (not name)
# to the environment. The full path is listed if you do
# conda info --envs at the command prompt.
conda activate /cluster/projects/nn8014k/programs/miniconda3

########################################################

# Execute the python program



# show me the loaded modules in a list
ml list 


# change directory to the program script 
cd /cluster/work/users/magdalena/GO_analysis/

# Commands for the program 
# To extract and translate the coding regions:
/cluster/projects/nn8014k/programs/miniconda3/bin/agat_sp_extract_sequences.pl \
 -g ccar_annotation.gtf \
 -f working.genome.masked.262contigs.fasta \
 -t cds -p -o ccar_cds.prot.fasta

# To extract the mRNA (biological definition UTR+CDS):
/cluster/projects/nn8014k/programs/miniconda3/bin/agat_sp_extract_sequences.pl \
 -g ccar_annotation.gtf \
 -f working.genome.masked.262contigs.fasta \
 -t exon --merge -o ccar_trans.transcript.fasta



# to close everything 
ml purge 

