#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Bismark_report_cc
#SBATCH --time=05:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --array=0-11

# load the needed modules


# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/10_bismark_report/

# Commands for the program (alignment of the reads to the genome)
input_alignment=("N1-D14-1_R1_val_1_bismark_bt2_PE_report.txt" \
       "N2-D15-1_R1_val_1_bismark_bt2_PE_report.txt" \
       "N3-D16-2_R1_val_1_bismark_bt2_PE_report.txt" \
       "N7-D36-1_R1_val_1_bismark_bt2_PE_report.txt" \
       "A1-D17-1_R1_val_1_bismark_bt2_PE_report.txt" \
       "A2-D18-1_R1_val_1_bismark_bt2_PE_report.txt" \
       "A4-D26-2_R1_val_1_bismark_bt2_PE_report.txt" \
       "A7-D37-1_R1_val_1_bismark_bt2_PE_report.txt" \
       "24R2-D21-2_R1_val_1_bismark_bt2_PE_report.txt" \
       "24R3-D22-2_R1_val_1_bismark_bt2_PE_report.txt" \
       "24R7-D38-1_R1_val_1_bismark_bt2_PE_report.txt" \
       "24R8-D39-1_R1_val_1_bismark_bt2_PE_report.txt" )

input_deduplication=("N1-D14-1_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "N2-D15-1_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "N3-D16-2_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "N7-D36-1_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "A1-D17-1_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "A2-D18-1_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "A4-D26-2_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "A7-D37-1_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "24R2-D21-2_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "24R3-D22-2_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "24R7-D38-1_R1_val_1_bismark_bt2_pe.deduplication_report.txt" \
       "24R8-D39-1_R1_val_1_bismark_bt2_pe.deduplication_report.txt" )

input_mbias=("N1-D14-1/N1-D14-1_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "N2-D15-1/N2-D15-1_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "N3-D16-2/N3-D16-2_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "N7-D36-1/N7-D36-1_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "A1-D17-1/A1-D17-1_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "A2-D18-1/A2-D18-1_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "A4-D26-2/A4-D26-2_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "A7-D37-1/A7-D37-1_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "24R2-D21-2/24R2-D21-2_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "24R3-D22-2/24R3-D22-2_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "24R7-D38-1/24R7-D38-1_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" \
       "24R8-D39-1/24R8-D39-1_R1_val_1_bismark_bt2_pe.deduplicated.M-bias.txt" )

input_splitting=("N1-D14-1_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "N2-D15-1_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "N3-D16-2_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "N7-D36-1_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "A1-D17-1_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "A2-D18-1_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "A4-D26-2_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "A7-D37-1_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "24R2-D21-2_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "24R3-D22-2_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "24R7-D38-1_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" \
       "24R8-D39-1_R1_val_1_bismark_bt2_pe.deduplicated_splitting_report.txt" )

input_nucleotide=("N1-D14-1_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "N2-D15-1_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "N3-D16-2_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "N7-D36-1_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "A1-D17-1_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "A2-D18-1_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "A4-D26-2_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "A7-D37-1_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "24R2-D21-2_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "24R3-D22-2_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "24R7-D38-1_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" \
       "24R8-D39-1_R1_val_1_bismark_bt2_pe.deduplicated.nucleotide_stats.txt" )



/cluster/projects/nn8014k/magdalena/.program_bismark/Bismark-0.24.1/bismark2report \
--alignment_report /cluster/projects/nn8014k/magdalena/script_WGBS/5_bismark_2alignment/fullseq/--min_score/${input_alignment[$SLURM_ARRAY_TASK_ID]} \
--dedup_report /cluster/projects/nn8014k/magdalena/script_WGBS/6_bismark_3deduplication/fullseq/${input_deduplication[$SLURM_ARRAY_TASK_ID]} \
--mbias_report /cluster/work/users/magdalena/7_bismark_methylation_extraction/${input_mbias[$SLURM_ARRAY_TASK_ID]} \
--splitting_report /cluster/projects/nn8014k/magdalena/script_WGBS/7_bismark_4mbias_plots/fullseq/${input_splitting[$SLURM_ARRAY_TASK_ID]} \
--nucleotide_report /cluster/projects/nn8014k/magdalena/script_WGBS/12_bismark_8nucleotide_coverage/fullseq/${input_nucleotide[$SLURM_ARRAY_TASK_ID]} \
--dir /cluster/work/users/magdalena/10_bismark_report/

# to close everything 
ml purge 











