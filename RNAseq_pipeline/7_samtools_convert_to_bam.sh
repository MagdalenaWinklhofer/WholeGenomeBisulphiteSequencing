#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=hisat2_alignment_cc
#SBATCH --time=27:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --array=0-11


# load the needed modules
module purge 

ml load SAMtools/1.17-GCC-12.2.0
ml load BCFtools/1.17-GCC-12.2.0

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/RNA/5_hisat_alignment/

# alignment of RNA sequences to the reference genome 
output1=("24R2.sam" \
         "24R3.sam" \
         "24R7.sam" \
         "24R8.sam" \
         "A1.sam" \
         "A2.sam" \
         "A4.sam" \
         "A7.sam" \
         "N1.sam" \
         "N2.sam" \
         "N3.sam" \
         "N7.sam")

output2=("24R2.bam" \
         "24R3.bam" \
         "24R7.bam" \
         "24R8.bam" \
         "A1.bam" \
         "A2.bam" \
         "A4.bam" \
         "A7.bam" \
         "N1.bam" \
         "N2.bam" \
         "N3.bam" \
         "N7.bam")



# use Samtools to sort and convert the SAM file (from hisat2 alignment) into a BAM file 
samtools sort -l 9 -o /cluster/work/users/magdalena/RNA/5_hisat_alignment/aligned_reads_bam/${output2[$SLURM_ARRAY_TASK_ID]} -O bam -@ 4 \
 /cluster/work/users/magdalena/RNA/5_hisat_alignment/aligned_reads_sam/${output1[$SLURM_ARRAY_TASK_ID]} \


# to close everything 
ml purge 

