#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Bismark_methylation_extraction_cc
#SBATCH --time=23:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --array=0-11


# load the needed modules
ml load Bowtie2/2.4.5-GCC-11.3.0
ml load SAMtools/1.16.1-GCC-11.3.0

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/7_bismark_methylation_extraction_DMRcaller/

# Commands for the program (alignment of the reads to the genome)
input=("N1-D14-1/N1-D14-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "N2-D15-1/N2-D15-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "N3-D16-2/N3-D16-2_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "N7-D36-1/N7-D36-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "A1-D17-1/A1-D17-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "A2-D18-1/A2-D18-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "A4-D26-2/A4-D26-2_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "A7-D37-1/A7-D37-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "24R2-D21-2/24R2-D21-2_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "24R3-D22-2/24R3-D22-2_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "24R7-D38-1/24R7-D38-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" \
       "24R8-D39-1/24R8-D39-1_R1_val_1_bismark_bt2_pe.deduplicated.bam" )

ignore=("5" \
        "10" \
        "8" \
        "4" \
        "4" \
        "10" \
        "8" \
        "4" \
        "10" \
        "11" \
        "10" \
        "8" )

ignore_r2=("5" \
        "13" \
        "10" \
        "10" \
        "10" \
        "15" \
        "14" \
        "12" \
        "13" \
        "13" \
        "12" \
        "13" )

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

/cluster/projects/nn8014k/magdalena/.program_bismark/Bismark-0.24.1/bismark_methylation_extractor --multicore 6 -p --gzip --parallel 6 --bedGraph --CX --cytosine_report \
 --genome_folder /cluster/projects/nn8014k/magdalena/script_WGBS/4_bismark_1index/ \
 --ignore ${ignore[$SLURM_ARRAY_TASK_ID]} --ignore_r2 ${ignore_r2[$SLURM_ARRAY_TASK_ID]} \
 --samtools_path /cluster/software/SAMtools/1.16.1-GCC-11.3.0/bin/samtools \
 --output /cluster/work/users/magdalena/7_bismark_methylation_extraction_DMRcaller/${output[$SLURM_ARRAY_TASK_ID]} \
 /cluster/work/users/magdalena/5_bismark_deduplication/${input[$SLURM_ARRAY_TASK_ID]}

# to close everything 
ml purge 









