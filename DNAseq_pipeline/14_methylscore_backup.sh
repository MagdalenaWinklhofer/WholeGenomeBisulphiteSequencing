#!/bin/bash
#SBATCH --account=nn8014k
#SBATCH --job-name=MethylScore_cc
#SBATCH --time=150:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --ntasks=40
#SBATCH --cpus-per-task=1

set -o errexit  # Exit the script on any error
set -o nounset  # Treat any unset variables as an error
module --quiet purge  # Reset the modules to the system default

# load the needed modules
module load Anaconda3/2022.10
source ${EBROOTANACONDA3}/bin/activate
conda activate /cluster/projects/nn8014k/magdalena/conda_environments/nextflow/


# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/DMR/

# Commands for the program 
export APPTAINER_TMPDIR=/cluster/work/users/magdalena/DMR/
export APPTAINER_CACHEDIR=/cluster/work/users/magdalena/DMR/

#export SINGULARITY_BIND="/cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/bwameth_alignment,/cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/14_DMR"
#export APPTAINER_TMPDIR=/cluster/work/users/magdalena/DMR/
#export APPTAINERENV_TMPDIR=/cluster/work/users/magdalena/DMR/
#export APPTAINERENV_NXF_DEBUG=/cluster/work/users/magdalena/DMR/.nextflow
#export NXF_HOME=/cluster/work/users/magdalena/DMR/.nextflow



nextflow run Computomics/MethylScore \
 --SAMPLE_SHEET=/cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/14_DMR/samplesheet.tsv \
 --GENOME=/cluster/work/users/magdalena/DMR/working.genome.masked.262contigs.fasta \
 -with-apptainer /cluster/work/users/magdalena/DMR/methylscore.sif
 
 
 #--cache /cluster/work/users/magdalena/DMR/ \
 #-c /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/14_DMR/nextflow.config 
 #-process.container = /cluster/work/users/magdalena/DMR/methylscore.sif
 #-with-singularity /cluster/work/users/magdalena/DMR/methylscore.sif

# to close everything 
ml purge 
