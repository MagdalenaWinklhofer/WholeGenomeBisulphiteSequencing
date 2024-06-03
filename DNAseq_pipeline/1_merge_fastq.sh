#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Merge_fastq_cc
#SBATCH --time=05:00:00
#SBATCH --mem=12G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --array=0-11

# load the needed modules
module purge 

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/DNA/

# Command of the program 
input_testseq_R1=("230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_1-N1-D14-1/1-N1-D14-1_S1_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_2-N2-D15-1/2-N2-D15-1_S8_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_3-N3-D16-2/3-N3-D16-2_S4_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_4-N7-D36-1/4-N7-D36-1_S5_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_5-A1-D17-1/5-A1-D17-1_S9_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_6-A2-D18-1/6-A2-D18-1_S3_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_7-A4-D26-2/7-A4-D26-2_S7_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_8-A7-D37-1/8-A7-D37-1_S11_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_9-24R2-D21-2/9-24R2-D21-2_S6_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_10-24R3-D22-2/10-24R3-D22-2_S2_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_11-24R7-D38-1/11-24R7-D38-1_S10_L001_R1_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_12-24R8-D39-1/12-24R8-D39-1_S12_L001_R1_001.fastq.gz" )

input_testseq_R2=("230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_1-N1-D14-1/1-N1-D14-1_S1_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_2-N2-D15-1/2-N2-D15-1_S8_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_3-N3-D16-2/3-N3-D16-2_S4_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_4-N7-D36-1/4-N7-D36-1_S5_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_5-A1-D17-1/5-A1-D17-1_S9_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_6-A2-D18-1/6-A2-D18-1_S3_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_7-A4-D26-2/7-A4-D26-2_S7_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_8-A7-D37-1/8-A7-D37-1_S11_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_9-24R2-D21-2/9-24R2-D21-2_S6_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_10-24R3-D22-2/10-24R3-D22-2_S2_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_11-24R7-D38-1/11-24R7-D38-1_S10_L001_R2_001.fastq.gz" \
               "230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_12-24R8-D39-1/12-24R8-D39-1_S12_L001_R2_001.fastq.gz" )

input_fullseq1_R1=("230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_1-N1-D14-1/1-N1-D14-1_S68_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_2-N2-D15-1/2-N2-D15-1_S72_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_3-N3-D16-2/3-N3-D16-2_S78_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_4-N7-D36-1/4-N7-D36-1_S74_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_5-A1-D17-1/5-A1-D17-1_S77_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_6-A2-D18-1/6-A2-D18-1_S75_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_7-A4-D26-2/7-A4-D26-2_S71_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_8-A7-D37-1/8-A7-D37-1_S70_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_9-24R2-D21-2/9-24R2-D21-2_S69_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_10-24R3-D22-2/10-24R3-D22-2_S73_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_11-24R7-D38-1/11-24R7-D38-1_S76_L004_R1_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_12-24R8-D39-1/12-24R8-D39-1_S79_L004_R1_001.fastq.gz" )

input_fullseq1_R2=("230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_1-N1-D14-1/1-N1-D14-1_S68_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_2-N2-D15-1/2-N2-D15-1_S72_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_3-N3-D16-2/3-N3-D16-2_S78_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_4-N7-D36-1/4-N7-D36-1_S74_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_5-A1-D17-1/5-A1-D17-1_S77_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_6-A2-D18-1/6-A2-D18-1_S75_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_7-A4-D26-2/7-A4-D26-2_S71_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_8-A7-D37-1/8-A7-D37-1_S70_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_9-24R2-D21-2/9-24R2-D21-2_S69_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_10-24R3-D22-2/10-24R3-D22-2_S73_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_11-24R7-D38-1/11-24R7-D38-1_S76_L004_R2_001.fastq.gz" \
               "230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11/Sample_12-24R8-D39-1/12-24R8-D39-1_S79_L004_R2_001.fastq.gz" )


input_fullseq2_R1=("240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_1-N1-D14-1/1-N1-D14-1_S116_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_2-N2-D15-1/2-N2-D15-1_S122_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_3-N3-D16-2/3-N3-D16-2_S121_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_4-N7-D36-1/4-N7-D36-1_S117_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_5-A1-D17-1/5-A1-D17-1_S123_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_6-A2-D18-1/6-A2-D18-1_S119_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_7-A4-D26-2/7-A4-D26-2_S126_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_8-A7-D37-1/8-A7-D37-1_S118_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_9-24R2-D21-2/9-24R2-D21-2_S127_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_10-24R3-D22-2/10-24R3-D22-2_S124_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_11-24R7-D38-1/11-24R7-D38-1_S120_L004_R1_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_12-24R8-D39-1/12-24R8-D39-1_S125_L004_R1_001.fastq.gz" )

input_fullseq2_R2=("240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_1-N1-D14-1/1-N1-D14-1_S116_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_2-N2-D15-1/2-N2-D15-1_S122_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_3-N3-D16-2/3-N3-D16-2_S121_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_4-N7-D36-1/4-N7-D36-1_S117_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_5-A1-D17-1/5-A1-D17-1_S123_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_6-A2-D18-1/6-A2-D18-1_S119_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_7-A4-D26-2/7-A4-D26-2_S126_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_8-A7-D37-1/8-A7-D37-1_S118_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_9-24R2-D21-2/9-24R2-D21-2_S127_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_10-24R3-D22-2/10-24R3-D22-2_S124_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_11-24R7-D38-1/11-24R7-D38-1_S120_L004_R2_001.fastq.gz" \
               "240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11/Sample_12-24R8-D39-1/12-24R8-D39-1_S125_L004_R2_001.fastq.gz" )


output_R1=("N1_R1.fastq.gz" \
        "N2_R1.fastq.gz" \
        "N3_R1.fastq.gz" \
        "N7_R1.fastq.gz" \
        "A1_R1.fastq.gz" \
        "A2_R1.fastq.gz" \
        "A4_R1.fastq.gz" \
        "A7_R1.fastq.gz" \
        "24R2_R1.fastq.gz" \
        "24R3_R1.fastq.gz" \
        "24R7_R1.fastq.gz" \
        "24R8_R1.fastq.gz" )

output_R2=("N1_R2.fastq.gz" \
        "N2_R2.fastq.gz" \
        "N3_R2.fastq.gz" \
        "N7_R2.fastq.gz" \
        "A1_R2.fastq.gz" \
        "A2_R2.fastq.gz" \
        "A4_R2.fastq.gz" \
        "A7_R2.fastq.gz" \
        "24R2_R2.fastq.gz" \
        "24R3_R2.fastq.gz" \
        "24R7_R2.fastq.gz" \
        "24R8_R2.fastq.gz" )

cat /cluster/work/users/magdalena/DNA/${input_testseq_R1[$SLURM_ARRAY_TASK_ID]} /cluster/work/users/magdalena/DNA/${input_fullseq1_R1[$SLURM_ARRAY_TASK_ID]} /cluster/work/users/magdalena/DNA/${input_fullseq2_R1[$SLURM_ARRAY_TASK_ID]} > /cluster/work/users/magdalena/DNA/1_merged_fastq/${output_R1[$SLURM_ARRAY_TASK_ID]} \

cat /cluster/work/users/magdalena/DNA/${input_testseq_R2[$SLURM_ARRAY_TASK_ID]} /cluster/work/users/magdalena/DNA/${input_fullseq1_R2[$SLURM_ARRAY_TASK_ID]} /cluster/work/users/magdalena/DNA/${input_fullseq2_R2[$SLURM_ARRAY_TASK_ID]} > /cluster/work/users/magdalena/DNA/1_merged_fastq/${output_R2[$SLURM_ARRAY_TASK_ID]} \


echo "Shallow sequencing R1 has $(wc -l < ${input_testseq_R1[$SLURM_ARRAY_TASK_ID]} ) lines"
echo "Fullseq one R1 has $(wc -l < ${input_fullseq1_R1[$SLURM_ARRAY_TASK_ID]} ) lines"
echo "Fullseq two R1 has $(wc -l < ${input_fullseq2_R1[$SLURM_ARRAY_TASK_ID]} ) lines"
sum_lines=$(paste -d+ <(wc -l < ${input_testseq_R1[$SLURM_ARRAY_TASK_ID]}) \
           <(wc -l < ${input_fullseq1_R1[$SLURM_ARRAY_TASK_ID]}) \
           <(wc -l < ${input_fullseq2_R1[$SLURM_ARRAY_TASK_ID]} ) | awk '{sum+=$1} END {print sum}')
echo "Sum of all three samples has ${sum_lines} lines"
merged_lines=$(wc -l /cluster/work/users/magdalena/DNA/1_merged_fastq/${output_R1[$SLURM_ARRAY_TASK_ID]} | awk '{print $1}')
echo "Merged R1 has ${merged_lines} lines"



echo "Shallow sequencing R2 has $(wc -l < ${input_testseq_R2[$SLURM_ARRAY_TASK_ID]} ) lines"
echo "Fullseq one R2 has $(wc -l < ${input_fullseq1_R2[$SLURM_ARRAY_TASK_ID]} ) lines"
echo "Fullseq two R2 has $(wc -l < ${input_fullseq2_R2[$SLURM_ARRAY_TASK_ID]} ) lines"
sum_lines=$(paste -d+ <(wc -l < ${input_testseq_R2[$SLURM_ARRAY_TASK_ID]}) \
           <(wc -l < ${input_fullseq1_R2[$SLURM_ARRAY_TASK_ID]}) \
           <(wc -l < ${input_fullseq2_R2[$SLURM_ARRAY_TASK_ID]} ) | awk '{sum+=$1} END {print sum}')
echo "Sum of all three samples has ${sum_lines} lines"
merged_lines=$(wc -l /cluster/work/users/magdalena/DNA/1_merged_fastq/${output_R2[$SLURM_ARRAY_TASK_ID]} | awk '{print $1}')
echo "Merged R2 has ${merged_lines} lines"


# to close everything 
ml purge 