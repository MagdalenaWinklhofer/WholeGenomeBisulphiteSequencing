#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=BWA-METH_indexing_cc
#SBATCH --time=30:00:00
#SBATCH --mem-per-cpu=12G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4

# activate the environment 
module load Anaconda3/2022.10
source ${EBROOTANACONDA3}/bin/activate
conda activate /cluster/projects/nn8014k/magdalena/conda_environments/bwameth

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/bwameth_index/

# Command of the program 
# Indexing the genome 
bwameth.py index /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/bwameth_index/ccar_genome_v1_262scaffolds_masked.fasta

# to close everything 
ml purge 