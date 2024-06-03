#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=hisat2_genome_index_cc
#SBATCH --time=24:00:00
#SBATCH --mem=150G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4


# load the needed modules
module purge 
module load HISAT2/2.2.1-gompi-2022a

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/RNA/5_hisat_alignment/genome_index/

# Build an index for your genome (is only done once) 
hisat2-build -p 16 --exon extracted_exons.exon --ss splice_sites.ss \
-f ccar_genome_v1_262scaffolds_masked.fasta crucian_carp_index

# to close everything 
ml purge 

