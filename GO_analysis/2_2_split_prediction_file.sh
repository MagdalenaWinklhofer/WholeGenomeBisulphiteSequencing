#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=split_file_cc
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


# load needed modules

# show me the loaded modules in a list
ml list 

# BLASTX - TRANSCRIPTS
# change directory 
cd /cluster/work/users/magdalena/GO_analysis/2_blastx
# Commands for the program 
split -l 2000 -d -a 3 ccar_trans.transcript_singleLine.fasta sub1000_
for i in sub1000_*; do mv $i $(echo $i | sed 's/\(sub1000_\)0\+\([1-9]*\)/\1\2/'); done
mv sub1000_ sub1000_0

# BLASTP - CDS
# change directory 
cd /cluster/work/users/magdalena/GO_analysis/3_blastp
# Commands for the program 
split -l 2000 -d -a 3 ccar_cds.prot_singleLine.fasta sub1000_
for i in sub1000_*; do mv $i $(echo $i | sed 's/\(sub1000_\)0\+\([1-9]*\)/\1\2/'); done
mv sub1000_ sub1000_0


# to close everything 
ml purge 





