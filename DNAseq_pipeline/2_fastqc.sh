#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Fastqc_cc
#SBATCH --time=05:00:00
#SBATCH --mem=12G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --array=23

# load the needed modules
module purge 
ml load FastQC/0.11.9-Java-11

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/DNA/

# Command of the program 
input=("N1_R1.fastq.gz" \
        "N2_R1.fastq.gz" \
        "N3_R1.fastq.gz" \
        "N7_R1.fastq.gz" \
        "A1_R1.fastq.gz" \
        "A2_R1.fastq.gz" \
        "A4_R1.fastq.gz" \
        "A7_R1.fastq.gz" \
        "24R2_R1.fastq.gz" \
        "24R3_R1.fastq.gz" \
        "24R7_R1.fastq.gz" \
        "24R8_R1.fastq.gz"\
        "N1_R2.fastq.gz" \
        "N2_R2.fastq.gz" \
        "N3_R2.fastq.gz" \
        "N7_R2.fastq.gz" \
        "A1_R2.fastq.gz" \
        "A2_R2.fastq.gz" \
        "A4_R2.fastq.gz" \
        "A7_R2.fastq.gz" \
        "24R2_R2.fastq.gz" \
        "24R3_R2.fastq.gz" \
        "24R7_R2.fastq.gz" \
        "24R8_R2.fastq.gz" )


fastqc \
 -o /cluster/work/users/magdalena/DNA/2_fastqc_before_trimming/ \
 /cluster/work/users/magdalena/DNA/1_merged_fastq/${input[$SLURM_ARRAY_TASK_ID]}


# to close everything 
ml purge 