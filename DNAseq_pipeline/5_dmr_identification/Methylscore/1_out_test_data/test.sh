#!/bin/bash
#SBATCH --account=nn8014k
#SBATCH --job-name=MethylScore_cc
#SBATCH --time=00:15:00
#SBATCH --mem-per-cpu=4G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


# change directory to the program script
cd /cluster/projects/nn8014k/magdalena/.program_methylscore/MethylScore/

# remove results and work directories
rm -rf results
rm -rf work


export NXF_APPTAINER_CACHEDIR=/cluster/work/users/magdalena/DMR/cache/


## Run command from MethylScore directory
/cluster/projects/nn8014k/magdalena/.program_methylscore/nextflow run main.nf \
	--SAMPLE_SHEET=test_data/samplesheet.tsv \
	--GENOME=test_data/ref.fasta \
    -profile slurm


# nextflow run main.nf --SAMPLE_SHEET=test_data/samplesheet.tsv --GENOME=test_data/ref.fasta -profile slurm

