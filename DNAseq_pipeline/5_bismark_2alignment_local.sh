#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Bismark_alignment_local_cc
#SBATCH --time=120:00:00
#SBATCH --mem-per-cpu=20G
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=6
#SBATCH --array=5-11


# load the needed modules
ml load Bowtie2/2.4.5-GCC-11.3.0
ml load SAMtools/1.16.1-GCC-11.3.0

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/projects/nn8014k/magdalena/.program_bismark/Bismark-0.24.1/

forward=("N1_R1_val_1.fq.gz" \
         "N2_R1_val_1.fq.gz" \
         "N3_R1_val_1.fq.gz" \
         "N7_R1_val_1.fq.gz" \
         "A1_R1_val_1.fq.gz" \
         "A2_R1_val_1.fq.gz" \
         "A4_R1_val_1.fq.gz" \
         "A7_R1_val_1.fq.gz" \
        "24R2_R1_val_1.fq.gz" \
        "24R3_R1_val_1.fq.gz" \
        "24R7_R1_val_1.fq.gz" \
        "24R8_R1_val_1.fq.gz" )

reverse=("N1_R2_val_2.fq.gz" \
         "N2_R2_val_2.fq.gz" \
         "N3_R2_val_2.fq.gz" \
         "N7_R2_val_2.fq.gz" \
         "A1_R2_val_2.fq.gz" \
         "A2_R2_val_2.fq.gz" \
         "A4_R2_val_2.fq.gz" \
         "A7_R2_val_2.fq.gz" \
        "24R2_R2_val_2.fq.gz" \
        "24R3_R2_val_2.fq.gz" \
        "24R7_R2_val_2.fq.gz" \
        "24R8_R2_val_2.fq.gz")

output=("N1" \
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
        "24R8" )


# Commands for the program (alignment of the reads to the genome)
./bismark --parallel 8 --local --non_directional --samtools_path /cluster/software/SAMtools/1.16.1-GCC-11.3.0/bin/samtools \
--temp_dir /cluster/work/users/magdalena/DNA/5_bismark_alignment_local/ \
--genome /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/4_bismark_1index/ \
-1 /cluster/work/users/magdalena/DNA/3_fastqc_after_trimming/${forward[$SLURM_ARRAY_TASK_ID]}  \
-2 /cluster/work/users/magdalena/DNA/3_fastqc_after_trimming/${reverse[$SLURM_ARRAY_TASK_ID]} \
--output_dir /cluster/work/users/magdalena/DNA/5_bismark_alignment_local/${output[$SLURM_ARRAY_TASK_ID]}

# to close everything 
ml purge 


