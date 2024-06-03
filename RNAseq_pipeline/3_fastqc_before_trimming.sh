#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Fastqc_cc
#SBATCH --time=24:00:00
#SBATCH --mem=8G
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --array=0-23%12

# load the needed modules
module purge 
ml load FastQC/0.11.9-Java-11

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/RNA/3_fastqc_before_trimming/

# Command of the program 
input=("Sample_1-24R2-R21/1-24R2-R21_S14_L002_R1_001.fastq.gz" \
         "Sample_1-24R2-R21/1-24R2-R21_S14_L002_R2_001.fastq.gz" \
         "Sample_2-24R3-R22/2-24R3-R22_S16_L002_R1_001.fastq.gz" \
         "Sample_2-24R3-R22/2-24R3-R22_S16_L002_R2_001.fastq.gz" \
         "Sample_3-24R7-R38/3-24R7-R38_S18_L002_R1_001.fastq.gz" \
         "Sample_3-24R7-R38/3-24R7-R38_S18_L002_R2_001.fastq.gz" \
         "Sample_4-24R8-R39/4-24R8-R39_S19_L002_R1_001.fastq.gz" \
         "Sample_4-24R8-R39/4-24R8-R39_S19_L002_R2_001.fastq.gz" \
         "Sample_5-A1-R17/5-A1-R17_S20_L002_R1_001.fastq.gz" \
         "Sample_5-A1-R17/5-A1-R17_S20_L002_R2_001.fastq.gz" \
         "Sample_6-A2-R18/6-A2-R18_S10_L002_R1_001.fastq.gz" \
         "Sample_6-A2-R18/6-A2-R18_S10_L002_R2_001.fastq.gz" \
         "Sample_7-A4-R26/7-A4-R26_S9_L002_R1_001.fastq.gz" \
         "Sample_7-A4-R26/7-A4-R26_S9_L002_R2_001.fastq.gz" \
         "Sample_8-A7-R37/8-A7-R37_S11_L002_R1_001.fastq.gz" \
         "Sample_8-A7-R37/8-A7-R37_S11_L002_R2_001.fastq.gz" \
         "Sample_9-N1-R14/9-N1-R14_S12_L002_R1_001.fastq.gz" \
         "Sample_9-N1-R14/9-N1-R14_S12_L002_R2_001.fastq.gz" \
         "Sample_10-N2-R15/10-N2-R15_S13_L002_R1_001.fastq.gz" \
         "Sample_10-N2-R15/10-N2-R15_S13_L002_R2_001.fastq.gz" \
         "Sample_11-N3-R16/11-N3-R16_S15_L002_R1_001.fastq.gz" \
         "Sample_11-N3-R16/11-N3-R16_S15_L002_R2_001.fastq.gz" \
         "Sample_12-N7-R36/12-N7-R36_S17_L002_R1_001.fastq.gz" \
         "Sample_12-N7-R36/12-N7-R36_S17_L002_R2_001.fastq.gz")
        
ouput=("24R2_R1" \
         "24R2_R2" \
         "24R3_R1" \
         "24R3_R2" \
         "24R7_R1" \
         "24R7_R2" \
         "24R8_R1" \
         "24R8_R2" \
         "A1_R1" \
         "A1_R2" \
         "A2_R1" \
         "A2_R2" \
         "A4_R1" \
         "A4_R2" \
         "A7_R1" \
         "A7_R2" \
         "N1_R1" \
         "N1_R2" \
         "N2_R1" \
         "N2_R2" \
         "N3_R1" \
         "N3_R2" \
         "N7_R1" \
         "N7_R2")


fastqc \
 -o /cluster/work/users/magdalena/RNA/3_fastqc_before_trimming/${output[$SLURM_ARRAY_TASK_ID]}  \
 /cluster/work/users/magdalena/RNA/231020_A01447.B.Project_Winklhofer-RNA1-2023-08-30/${input[$SLURM_ARRAY_TASK_ID]} 

# to close everything 
ml purge 









