#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Methylpy_cc
#SBATCH --time=27:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
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
input1=("N1-D14-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "N2-D15-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "N3-D16-2_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "N7-D36-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "A1-D17-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "A2-D18-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "A4-D26-2_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "A7-D37-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "24R2-D21-2_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "24R3-D22-2_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "24R7-D38-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "24R8-D39-1_R1_val_1_bismark_bt2_pe.deduplicated.bam")

output1=("N1_sorted.bam" \
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

input2=("N1_sorted.bam" \
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

output2=("N1_indexed.bai" \
        "N2_indexed.bai" \
        "N3_indexed.bai" \
        "N7_indexed.bai" \
        "A1_indexed.bai" \
        "A2_indexed.bai" \
        "A4_indexed.bai" \
        "A7_indexed.bai" \
        "24R2_indexed.bai" \
        "24R3_indexed.bai" \
        "24R7_indexed.bai" \
        "24R8_indexed.bai")

# I performed the analysis in two setps: first sorting the bam files and then indexing them. I performed two runs. 
#First run I diabled the second line of code and the second run I disabled the first line of code.
samtools sort ${input1[$SLURM_ARRAY_TASK_ID]} -o ${output1[$SLURM_ARRAY_TASK_ID]}
samtools index -M -b ${input2[$SLURM_ARRAY_TASK_ID]} ${output2[$SLURM_ARRAY_TASK_ID]}

# to close everything 
ml purge 

