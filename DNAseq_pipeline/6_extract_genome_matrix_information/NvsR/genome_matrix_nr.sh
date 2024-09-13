#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=extract_genome_matricx_info
#SBATCH --time=10:00:00
#SBATCH --mem=24G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3

# load the needed modules
module purge 

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/6_extract_genome_matrix_information/

# Command of the program 
# NORMOXIA vs REOXYGENATION

# copy genome matrix from mtehylscore output into this directory 
cp /cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/5_dmr_identification/Methylscore/3_out_N_vs_R/ouput/03matrix/genome_matrix.tsv.gz \
 /cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/6_extract_genome_matrix_information/NvsR/

# move into subdir 
cd NvsR/

#unzip file 
gzip -d genome_matrix.tsv.gz

# Extract CG lines and keep forward (C) and reverse (G)
{
  head -n 1 genome_matrix.tsv   # Copy the header
  grep -P '^[^\t]+\t[^\t]+\tCG\t' genome_matrix.tsv  # Copy lines where the 3rd column is "CG"
} > genome_matrix_CG_CG.tsv

# Extract C (forward lines) from the CG lines
{
  head -n 1 genome_matrix_CG_CG.tsv    # Copy the header
  grep -P '^[^\t]+\t[^\t]+\tCG\tC\t' genome_matrix_CG_CG.tsv  # Copy lines where the 4th column is 'C'
} > genome_matrix_CG_C.tsv

# Extract G (reverse lines) from the CG lines
{
  head -n 1 genome_matrix_CG_CG.tsv    # Copy the header
  grep -P '^[^\t]+\t[^\t]+\tCG\tG\t' genome_matrix_CG_CG.tsv  # Copy lines where the 4th column is 'G'
} > genome_matrix_CG_G.tsv


mkdir bed_files_C
mv genome_matrix_CG_C.tsv /cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/6_extract_genome_matrix_information/NvsA/bed_files_C/


mkdir bed_files_G
mv genome_matrix_CG_G.tsv /cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/6_extract_genome_matrix_information/NvsA/bed_files_G/