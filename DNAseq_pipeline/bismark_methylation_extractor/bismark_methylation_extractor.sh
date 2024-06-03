#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Bismark_methylation_extraction_cc
#SBATCH --time=36:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=4
#SBATCH --array=0-11


# load the needed modules
ml load Bowtie2/2.4.5-GCC-11.3.0
ml load SAMtools/1.16.1-GCC-11.3.0

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/DMR_alternative/alignments/

# Commands for the program (alignment of the reads to the genome)

input=("N1-D14-1.bam" \
        "N2-D15-1.bam" \
        "N3-D16-2.bam" \
        "N7-D36-1.bam" \
        "A1-D17-1.bam" \
        "A2-D18-1.bam" \
        "A4-D26-2.bam" \
        "A7-D37-1.bam" \
        "24R2-D21-2.bam" \
        "24R3-D22-2.bam" \
        "24R7-D38-1.bam" \
        "24R8-D39-1.bam" )

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

./bismark_methylation_extractor --multicore 6 -p --bedGraph --gzip --parallel 6 \
 --ignore ${ignore[$SLURM_ARRAY_TASK_ID]} --ignore_r2 ${ignore_r2[$SLURM_ARRAY_TASK_ID]} \
 --samtools_path /cluster/software/SAMtools/1.16.1-GCC-11.3.0/bin/samtools \
 --output /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/bismark_methylation_extractor/${output[$SLURM_ARRAY_TASK_ID]} \
 /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/bismark_deduplication/${input[$SLURM_ARRAY_TASK_ID]}

# to close everything 
ml purge 











