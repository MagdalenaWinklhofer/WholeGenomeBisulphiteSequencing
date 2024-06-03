#!/bin/bash
#SBATCH --account=nn8014k
#SBATCH --job-name=MethylScore_cc
#SBATCH --time=330:00:00
#SBATCH --partition=bigmem
#SBATCH --mem=300G
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=6


rm -rf results
rm -rf work


# Commands for the program 
export NXF_APPTAINER_CACHEDIR=/cluster/work/users/magdalena/DMR/cache/

## Run command from MethylScore directory
./../nextflow run Computomics/MethylScore \
    --PROJECT_FOLDER=/cluster/work/users/magdalena/DMR/MethylScore/DMR_A_vs_R \
    --SAMPLE_SHEET=samplesheet_a_vs_r.tsv \
	--GENOME=ccar_genome_v1_262scaffolds_masked.fasta \
    -profile slurm

# to close everything 
ml purge 
