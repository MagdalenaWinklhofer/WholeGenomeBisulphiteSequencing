#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=hisat2_alignment_cc
#SBATCH --time=27:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --array=0-11


# load the needed modules
module purge 

ml load HISAT2/2.2.1-gompi-2022a
#ml load SAMtools/1.17-GCC-12.2.0
#ml load BCFtools/1.17-GCC-12.2.0

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/RNA/5_hisat_alignment/

# alignment of RNA sequences to the reference genome 


input1_forward=("/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/1-24R2-R21_S14_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/2-24R3-R22_S16_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/3-24R7-R38_S18_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/4-24R8-R39_S19_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/5-A1-R17_S20_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/6-A2-R18_S10_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/7-A4-R26_S9_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/8-A7-R37_S11_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/9-N1-R14_S12_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/10-N2-R15_S13_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/11-N3-R16_S15_L002_R1_001_val_1.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/12-N7-R36_S17_L002_R1_001_val_1.fq.gz")

input1_reverse=("/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/1-24R2-R21_S14_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/2-24R3-R22_S16_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/3-24R7-R38_S18_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/4-24R8-R39_S19_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/5-A1-R17_S20_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/6-A2-R18_S10_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/7-A4-R26_S9_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/8-A7-R37_S11_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/9-N1-R14_S12_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/10-N2-R15_S13_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/11-N3-R16_S15_L002_R2_001_val_2.fq.gz" \
         "/cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/12-N7-R36_S17_L002_R2_001_val_2.fq.gz")

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

output2=("24R2" \
         "24R3" \
         "24R7" \
         "24R8" \
         "A1" \
         "A2" \
         "A4" \
         "A7" \
         "N1" \
         "N2" \
         "N3" \
         "N7")

# alignment of RNA sequences to the reference genome
hisat2 -p 4 --reorder --summary-file cc_alignment_summary_${output2[$SLURM_ARRAY_TASK_ID]} /cluster/work/users/magdalena/RNA/5_hisat_alignment/genome_index/crucian_carp_index \
-1 ${input1_forward[$SLURM_ARRAY_TASK_ID]} \
-2 ${input1_reverse[$SLURM_ARRAY_TASK_ID]} \
-S /cluster/work/users/magdalena/RNA/5_hisat_alignment/aligned_reads_sam/${output1[$SLURM_ARRAY_TASK_ID]} 


# use Samtools to sort and convert the SAM file (from hisat2 alignment) into a BAM file 
#samtools sort -l 9 -o /cluster/work/users/magdalena/RNA/5_hisat_alignment/aligned_reads_bam/${output2[$SLURM_ARRAY_TASK_ID]} -O bam -@ 4 \
# /cluster/work/users/magdalena/RNA/5_hisat_alignment/aligned_reads_sam/${output1[$SLURM_ARRAY_TASK_ID]} \


# to close everything 
ml purge 

