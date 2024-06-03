#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Methylpy_cc
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --array=0-11


# load the needed modules
module load Anaconda3/2022.10
source ${EBROOTANACONDA3}/bin/activate
conda activate /cluster/projects/nn8014k/magdalena/conda_environments/methylpy_env
ml load  SAMtools/1.17-GCC-12.2.0
ml load Bowtie2/2.5.1-GCC-12.2.0

# show me the loaded modules in a list
ml list 

# it is good to have the following lines in any bash script
set -o errexit  # make bash exit on any error
set -o nounset  # treat unset variables as errors

# change directory to the program script 
cd /cluster/work/users/magdalena/11_DML/

# Commands for the program 
#METHYLATION CALLING
input=("N1_sorted.bam" \
        "N2_sorted.bam" \
        "N3_sorted.bam" \
        "N7_sorted.bam" \
        "A1_sorted.bam" \
        "A2_sorted.bam" \
        "A4_sorted.bam" \
        "A7_sorted.bam" \
        "24R2_sorted.bam" \
        "24R3_sorted.bam" \
        "24R7_sorted.bam" \
        "24R8_sorted.bam")

sample=("N1" \
        "N2" \
        "N3" \
        "N7" \
        "A1" \
        "A2" \
        "A4" \
        "A7" \
        "24R2" \
        "24R3" \
        "24R7" \
        "24R8")

 methylpy call-methylation-state \
	--input-file ${input[$SLURM_ARRAY_TASK_ID]} \
	--paired-end True \
	--sample ${sample[$SLURM_ARRAY_TASK_ID]} \
	--ref-fasta /cluster/work/users/magdalena/11_DML/working.genome.masked.262contigs.fasta \
	--num-procs 2 \
	--path-to-output /cluster/work/users/magdalena/11_DML/ \


 #methylpy call-methylation-state \
#	--input-file 24R3_sorted.bam \
#	--paired-end True \
#	--sample 24R3 \
#	--ref-fasta /cluster/work/users/magdalena/11_DML/working.genome.masked.262contigs.fasta \
#	--num-procs 1 \
#	--path-to-output /cluster/work/users/magdalena/11_DML/ \



# to close everything 
ml purge 

