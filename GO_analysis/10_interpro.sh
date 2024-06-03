#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Interpro_cc
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --array=0-65

# unload all modules
module purge

set -o errexit  # Exit the script on any error
set -o nounset  # Treat any unset variables as an error

# load the needed modules
ml load InterProScan_data/5.62-94.0-foss-2022a

#change location to the folder where the data is: 
cd  /cluster/work/users/magdalena/GO_analysis/7_interproScan/

#command for protein sequences:
interproscan.sh \
-t p \
-i protein_sub1000_$SLURM_ARRAY_TASK_ID \
-f tsv -dp -goterms \
-tempdir /cluster/work/users/magdalena/GO_analysis/7_interproScan/ \
-o protein_interpro.$SLURM_ARRAY_TASK_ID \
#-verbose \

# command for nucleotide sequences:
#interproscan.sh \
#-t n \
#-i transcript_sub1000_$SLURM_ARRAY_TASK_ID \
#-f tsv -dp -goterms \
#-tempdir /cluster/work/users/magdalena/GO_analysis/7_interproScan/ \
#-o transcript_interpro.$SLURM_ARRAY_TASK_ID \
#-verbose \

# close all
ml purge 