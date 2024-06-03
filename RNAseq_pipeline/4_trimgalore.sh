#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=TrimGalore_cc
#SBATCH --time=22:00:00
#SBATCH --mem=12G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --array=0-11

# load the needed modules
module purge 
ml load Trim_Galore/0.6.10-GCCcore-11.2.0
ml load cutadapt/3.5-GCCcore-11.2.0
ml load FastQC/0.11.9-Java-11

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/

# Command of the program 
input1_forward=("Sample_1-24R2-R21/1-24R2-R21_S14_L002_R1_001.fastq.gz" \
         "Sample_2-24R3-R22/2-24R3-R22_S16_L002_R1_001.fastq.gz" \
         "Sample_3-24R7-R38/3-24R7-R38_S18_L002_R1_001.fastq.gz" \
         "Sample_4-24R8-R39/4-24R8-R39_S19_L002_R1_001.fastq.gz" \
         "Sample_5-A1-R17/5-A1-R17_S20_L002_R1_001.fastq.gz" \
         "Sample_6-A2-R18/6-A2-R18_S10_L002_R1_001.fastq.gz" \
         "Sample_7-A4-R26/7-A4-R26_S9_L002_R1_001.fastq.gz" \
         "Sample_8-A7-R37/8-A7-R37_S11_L002_R1_001.fastq.gz" \
         "Sample_9-N1-R14/9-N1-R14_S12_L002_R1_001.fastq.gz" \
         "Sample_10-N2-R15/10-N2-R15_S13_L002_R1_001.fastq.gz" \
         "Sample_11-N3-R16/11-N3-R16_S15_L002_R1_001.fastq.gz" \
         "Sample_12-N7-R36/12-N7-R36_S17_L002_R1_001.fastq.gz")

input1_reverse=( "Sample_1-24R2-R21/1-24R2-R21_S14_L002_R2_001.fastq.gz" \
         "Sample_2-24R3-R22/2-24R3-R22_S16_L002_R2_001.fastq.gz" \
         "Sample_3-24R7-R38/3-24R7-R38_S18_L002_R2_001.fastq.gz" \
         "Sample_4-24R8-R39/4-24R8-R39_S19_L002_R2_001.fastq.gz" \
         "Sample_5-A1-R17/5-A1-R17_S20_L002_R2_001.fastq.gz" \
         "Sample_6-A2-R18/6-A2-R18_S10_L002_R2_001.fastq.gz" \
         "Sample_7-A4-R26/7-A4-R26_S9_L002_R2_001.fastq.gz" \
         "Sample_8-A7-R37/8-A7-R37_S11_L002_R2_001.fastq.gz" \
         "Sample_9-N1-R14/9-N1-R14_S12_L002_R2_001.fastq.gz" \
         "Sample_10-N2-R15/10-N2-R15_S13_L002_R2_001.fastq.gz" \
         "Sample_11-N3-R16/11-N3-R16_S15_L002_R2_001.fastq.gz" \
         "Sample_12-N7-R36/12-N7-R36_S17_L002_R2_001.fastq.gz")


ouput=("24R2" \
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

trim_galore \
--cores 2 \
--paired \
--quality 20 \
--fastqc \
-o /cluster/work/users/magdalena/RNA/4_fastqc_after_trimming/${output[$SLURM_ARRAY_TASK_ID]} \
 /cluster/work/users/magdalena/RNA/231020_A01447.B.Project_Winklhofer-RNA1-2023-08-30/${input1_forward[$SLURM_ARRAY_TASK_ID]} \
 /cluster/work/users/magdalena/RNA/231020_A01447.B.Project_Winklhofer-RNA1-2023-08-30/${input1_reverse[$SLURM_ARRAY_TASK_ID]}


# to close everything 
ml purge 