#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Bismark_genome_preparation_cc
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=4

# activate the environment 
ml load  Bowtie2/2.5.1-GCC-12.2.0

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/projects/nn8014k/magdalena/.program_bismark/Bismark-0.24.1/

# Command of the program 
./bismark_genome_preparation --bowtie2 --parallel 2 /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/4_bismark_1index/

# close all modules
ml purge 