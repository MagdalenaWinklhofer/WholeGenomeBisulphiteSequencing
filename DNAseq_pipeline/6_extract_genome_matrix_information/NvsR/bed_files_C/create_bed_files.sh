#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=create_bed_files
#SBATCH --time=10:00:00
#SBATCH --mem=24G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2

# load the needed modules
module purge 
ml load Python/3.11.5-GCCcore-13.2.0
module load Anaconda3/2022.10
source ${EBROOTANACONDA3}/bin/activate
conda activate /cluster/projects/nn8014k/magdalena/conda_environments/general

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/6_extract_genome_matrix_information/NvsA/bed_files_C/

# Command of the program 
python create_bed_files.py

