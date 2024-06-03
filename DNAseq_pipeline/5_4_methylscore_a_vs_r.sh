#!/bin/bash
#SBATCH --account=nn8014k
#SBATCH --job-name=MethylScore_cc
#SBATCH --partition=bigmem
#SBATCH --time=330:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

# change directory to the program script
cd /cluster/work/users/magdalena/DMR/MethylScore/


export NXF_APPTAINER_CACHEDIR=/cluster/work/users/magdalena/DMR/cache/

## Run command from MethylScore directory
/cluster/projects/nn8014k/magdalena/.program_methylscore/nextflow run Computomics/MethylScore \
    --PROJECT_FOLDER=/cluster/work/users/magdalena/DMR/data/DMR_A_vs_R \
    --SAMPLE_SHEET=/cluster/work/users/magdalena/DMR/data/samplesheet_a_vs_r.tsv \
	--GENOME=/cluster/work/users/magdalena/DMR/data/ccar_genome_v1_262scaffolds_masked.fasta \
    -profile slurm

# to close everything 
ml purge 

# squeue --me -o "%.18i %.9P %.8j %.8u %.2t %.10M %.6D %R %.10C %.10m" --iterate=30
