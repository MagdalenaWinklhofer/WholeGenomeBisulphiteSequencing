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


# Commands for the program 
export APPTAINER_TMPDIR=$USERWORK
export APPTAINER_CACHEDIR=$USERWORK

/cluster/work/users/magdalena/nextflow run Computomics/MethylScore --SAMPLE_SHEET=./samplesheet.tsv --GENOME=./working.genome.masked.262contigs.fasta -with-apptainer methylscore.sif
 

# to close everything 
ml purge 
