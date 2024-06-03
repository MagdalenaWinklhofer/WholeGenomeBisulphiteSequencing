#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=split_file_cc
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


# load needed modules
ml load  seqtk/1.4-GCC-12.2.0
# show me the loaded modules in a list
ml list 


# change directory to the program script 
cd /cluster/work/users/magdalena/GO_analysis/

# Commands for the program 
seqtk seq -l0 ccar_cds.prot.fasta > ccar_cds.prot_singleLine.fasta
seqtk seq -l0 ccar_trans.transcript.fasta > ccar_trans.transcript_singleLine.fasta


# to close everything 
ml purge 





