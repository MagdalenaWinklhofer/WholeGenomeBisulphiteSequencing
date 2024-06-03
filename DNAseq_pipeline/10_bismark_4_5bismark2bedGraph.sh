#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Bismark_2bedGraph_cc
#SBATCH --time=15:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --array=0-11

# load the needed modules
ml load Bowtie2/2.4.5-GCC-11.3.0
ml load SAMtools/1.16.1-GCC-11.3.0

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/8_bismark_bedGraph/

# Commands for the program (alignment of the reads to the genome)
input=("N1-D14-1/CpG_context_N1-D14-1_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "N2-D15-1/CpG_context_N2-D15-1_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "N3-D16-2/CpG_context_N3-D16-2_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "N7-D36-1/CpG_context_N7-D36-1_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "A1-D17-1/CpG_context_A1-D17-1_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "A2-D18-1/CpG_context_A2-D18-1_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "A4-D26-2/CpG_context_A4-D26-2_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "A7-D37-1/CpG_context_A7-D37-1_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "24R2-D21-2/CpG_context_24R2-D21-2_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "24R3-D22-2/CpG_context_24R3-D22-2_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "24R7-D38-1/CpG_context_24R7-D38-1_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" \
       "24R8-D39-1/CpG_context_24R8-D39-1_R1_val_1_bismark_bt2_pe.deduplicated.txt.gz" )

output=("N1-D14-1.bedGraph" \
        "N2-D15-1.bedGraph" \
        "N3-D16-2.bedGraph" \
        "N7-D36-1.bedGraph" \
        "A1-D17-1.bedGraph" \
        "A2-D18-1.bedGraph" \
        "A4-D26-2.bedGraph" \
        "A7-D37-1.bedGraph" \
        "24R2-D21-2.bedGraph" \
        "24R3-D22-2.bedGraph" \
        "24R7-D38-1.bedGraph" \
        "24R8-D39-1.bedGraph" )

/cluster/projects/nn8014k/magdalena/.program_bismark/Bismark-0.24.1/bismark2bedGraph \
 /cluster/work/users/magdalena/7_bismark_methylation_extraction/${input[$SLURM_ARRAY_TASK_ID]} \
 --dir /cluster/work/users/magdalena/8_bismark_bedGraph/ \
 --output ${output[$SLURM_ARRAY_TASK_ID]}

# to close everything 
ml purge 











