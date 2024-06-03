#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=TrimGalore_cc
#SBATCH --time=22:00:00
#SBATCH --mem=8G
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=4
#SBATCH --array=0-11

# load the needed modules
module purge 
ml load Trim_Galore/0.6.10-GCCcore-11.2.0
ml load cutadapt/3.5-GCCcore-11.2.0
ml load FastQC/0.11.9-Java-11

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/DNA/

# Command of the program 
input1_forward=("/cluster/work/users/magdalena/DNA/1_merged_fastq/N1_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/N2_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/N3_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/N7_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/A1_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/A2_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/A4_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/A7_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/24R2_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/24R3_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/24R7_R1.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/24R8_R1.fastq.gz")

input1_reverse=("/cluster/work/users/magdalena/DNA/1_merged_fastq/N1_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/N2_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/N3_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/N7_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/A1_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/A2_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/A4_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/A7_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/24R2_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/24R3_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/24R7_R2.fastq.gz"
"/cluster/work/users/magdalena/DNA/1_merged_fastq/24R8_R2.fastq.gz")

trim_galore \
--cores 4 \
--paired \
--quality 20 \
--length 20 \
--fastqc \
--clip_R1 10 \
--clip_r2 10 \
--three_prime_clip_R1 10 \
--three_prime_clip_R2 10 \
-o /cluster/work/users/magdalena/DNA/3_fastqc_after_trimming/ \
 ${input1_forward[$SLURM_ARRAY_TASK_ID]} \
 ${input1_reverse[$SLURM_ARRAY_TASK_ID]}

# the quality setting is the default 
# run fastqc after trimming 
# length: is default (cut if the length of the reads gets shorter than 20 bps)
# clipping settings are recommended by Bismark for the library type (Zymo Pico-Methyl)

# to close everything 
ml purge 