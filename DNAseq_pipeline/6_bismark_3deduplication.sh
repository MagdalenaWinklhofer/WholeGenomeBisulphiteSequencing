#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Bismark_deduplication_cc
#SBATCH --time=72:00:00
#SBATCH --mem-per-cpu=12G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --array=0-11

# load the needed modules
ml load  SAMtools/1.17-GCC-12.2.0

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/projects/nn8014k/magdalena/.program_bismark/Bismark-0.24.1/

# Commands for the program
input=("N1-D14-1/N1-D14-1_R1_val_1_bismark_bt2_pe.bam " \
       "N2-D15-1/N2-D15-1_R1_val_1_bismark_bt2_pe.bam" \
       "N3-D16-2/N3-D16-2_R1_val_1_bismark_bt2_pe.bam " \
       "N7-D36-1/N7-D36-1_R1_val_1_bismark_bt2_pe.bam" \
       "A1-D17-1/A1-D17-1_R1_val_1_bismark_bt2_pe.bam" \
       "A2-D18-1/A2-D18-1_R1_val_1_bismark_bt2_pe.bam" \
       "A4-D26-2/A4-D26-2_R1_val_1_bismark_bt2_pe.bam" \
       "A7-D37-1/A7-D37-1_R1_val_1_bismark_bt2_pe.bam" \
       "24R2-D21-2/24R2-D21-2_R1_val_1_bismark_bt2_pe.bam" \
       "24R3-D22-2/24R3-D22-2_R1_val_1_bismark_bt2_pe.bam" \
       "24R7-D38-1/24R7-D38-1_R1_val_1_bismark_bt2_pe.bam" \
       "24R8-D39-1/24R8-D39-1_R1_val_1_bismark_bt2_pe.bam" )

output=("N1-D14-1" \
        "N2-D15-1" \
        "N3-D16-2" \
        "N7-D36-1" \
        "A1-D17-1" \
        "A2-D18-1" \
        "A4-D26-2" \
        "A7-D37-1" \
        "24R2-D21-2" \
        "24R3-D22-2" \
        "24R7-D38-1" \
        "24R8-D39-1" )

./deduplicate_bismark -p /cluster/work/users/magdalena/4_bismark_alignment/${input[$SLURM_ARRAY_TASK_ID]} \
--samtools_path /cluster/software/SAMtools/1.16.1-GCC-11.3.0/bin/samtools \
--output_dir /cluster/work/users/magdalena/5_bismark_deduplication/${output[$SLURM_ARRAY_TASK_ID]}

# to close everything 
ml purge 







