#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=BWA-METH_alignment_cc
#SBATCH --time=335:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --partition=bigmem
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=20
#SBATCH --array=0-11

# activate the environment 
module load Anaconda3/2022.10
source ${EBROOTANACONDA3}/bin/activate
conda activate /cluster/projects/nn8014k/magdalena/conda_environments/bwameth
ml load SAMtools/1.17-GCC-12.2.0
# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/projects/nn8014k/magdalena/script_WGBS/

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



# Command of the program 
bwameth.py --reference /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/bwameth_index/ccar_genome_v1_262scaffolds_masked.fasta \
 /cluster/work/users/magdalena/DNA/3_fastqc_after_trimming/${forward[$SLURM_ARRAY_TASK_ID]} /cluster/work/users/magdalena/DNA/3_fastqc_after_trimming/${reverse[$SLURM_ARRAY_TASK_ID]} \
-t 8 \
| samtools view -b - > /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/bwameth_alignment${output[$SLURM_ARRAY_TASK_ID]}_aligned.bam


# close all modules
ml purge 