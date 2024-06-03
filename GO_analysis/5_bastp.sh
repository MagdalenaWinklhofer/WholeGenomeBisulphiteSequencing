#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Blastp_cc
#SBATCH --time=01:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --array=0-65

# unload all modules
module purge


set -o errexit  # Exit the script on any error
set -o nounset  # Treat any unset variables as an error

# load the needed modules
ml load BLAST+/2.14.1-gompi-2023a
# sjannie used: module load BLAST+/2.10.1-gompi-2020a


cd  /cluster/work/users/magdalena/GO_analysis/3_blastp/

## run blastx with subfiles and output a blastoutput file that has the ID of the task.
blastp \
-db uniprot_sprot.fasta \
 -query sub1000_$SLURM_ARRAY_TASK_ID \
 -out /cluster/work/users/magdalena/GO_analysis/3_blastp/blastp.$SLURM_ARRAY_TASK_ID.txt \
 -evalue 1e-5 -outfmt 6 -num_threads 4



