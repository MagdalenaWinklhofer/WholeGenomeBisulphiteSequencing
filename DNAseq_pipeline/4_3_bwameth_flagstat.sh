#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=BWA-METH_flagstat_cc
#SBATCH --time=01:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --array=0-11

# activate the environment 
module load Anaconda3/2022.10
source ${EBROOTANACONDA3}/bin/activate
conda activate /cluster/projects/nn8014k/magdalena/conda_environments/bwameth
ml load SAMtools/1.17-GCC-12.2.0
# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/DMR/alignment_bwa_meth/

input=("bwameth_alignmentN1_aligned.bam" \
       "bwameth_alignmentN2_aligned.bam" \
       "bwameth_alignmentN3_aligned.bam" \
       "bwameth_alignmentN7_aligned.bam" \
       "bwameth_alignmentA1_aligned.bam" \
       "bwameth_alignmentA2_aligned.bam" \
       "bwameth_alignmentA4_aligned.bam" \
       "bwameth_alignmentA7_aligned.bam" \
       "bwameth_alignment24R2_aligned.bam" \
       "bwameth_alignment24R3_aligned.bam" \
       "bwameth_alignment24R7_aligned.bam" \
       "bwameth_alignment24R8_aligned.bam" )

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


# Command of the program 
samtools flagstat ${input[$SLURM_ARRAY_TASK_ID]} > /cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/4_3_bwameth_stats/output_${output[$SLURM_ARRAY_TASK_ID]}


# close all modules
ml purge 