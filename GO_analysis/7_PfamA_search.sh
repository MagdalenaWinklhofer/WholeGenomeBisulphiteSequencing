#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Pfam_cc
#SBATCH --time=27:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --array=0-65


# load modules
module load  HMMER/3.3.2-gompi-2022b


# show me the loaded modules in a list
ml list 


# change directory to the program script 
cd /cluster/work/users/magdalena/GO_analysis/5_protein_family_search/

# Commands for the program 
## running hmmscan2 (saga, start 210120 14.02,):
hmmscan --cpu 4 -E 1e-7 \
 --domtblout hmmscan2.$SLURM_ARRAY_TASK_ID.txt \
/cluster/work/users/magdalena/GO_analysis/5_protein_family_search/Pfam-A.hmm \
/cluster/work/users/magdalena/GO_analysis/3_blastp/sub1000_$SLURM_ARRAY_TASK_ID

# to close everything 
ml purge 











