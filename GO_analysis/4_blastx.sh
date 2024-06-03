#!/bin/bash


#SBATCH --account=nn8014k
#SBATCH --job-name=Blastx_cc
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --array=0-65


set -o errexit  # Exit the script on any error
set -o nounset  # Treat any unset variables as an error

# load the needed modules
ml load BLAST+/2.14.1-gompi-2023a
module load Anaconda3/2022.10
source ${EBROOTANACONDA3}/bin/activate
conda activate /cluster/projects/nn8014k/magdalena/conda_environments/trinotate

cd /cluster/work/users/magdalena/GO_analysis/2_blastx/

## run blastx with subfiles and output a blastoutput file that has the ID of the task.
blastx \
 -db uniprot_sprot.fasta \
 -query sub1000_$SLURM_ARRAY_TASK_ID \
 -out /cluster/work/users/magdalena/GO_analysis/2_blastx/blastx.$SLURM_ARRAY_TASK_ID.txt \
 -evalue 1e-5 -outfmt 6 -num_threads 4
