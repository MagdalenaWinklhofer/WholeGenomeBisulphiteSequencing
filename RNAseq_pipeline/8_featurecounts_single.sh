#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=featurecounts_cc
#SBATCH --time=25:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --array=0-11


# load the needed modules
ml load Subread/2.0.3-GCC-11.2.0

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/RNA/6_featureCounts/single/

# additional settings 
set -o errexit  # Exit the script on any error
set -o nounset  # Treat any unset variables as an error

# Commands for the program (alignment of the reads to the genome)
echo running featureCounts

input=("A1.bam" \
       "A2.bam" \
       "A4.bam" \
       "A7.bam" \
       "N1.bam" \
       "N2.bam" \
       "N3.bam" \
       "N7.bam" \
       "24R2.bam" \
       "24R3.bam" \
       "24R7.bam" \
       "24R8.bam" )

output=("cc_counts_A1.txt" \
       "cc_counts_A2.txt" \
       "cc_counts_A4.txt" \
       "cc_counts_A7.txt" \
       "cc_counts_N1.txt" \
       "cc_counts_N2.txt" \
       "cc_counts_N3.txt" \
       "cc_counts_N7.txt" \
       "cc_counts_24R2.txt" \
       "cc_counts_24R3.txt" \
       "cc_counts_24R7.txt" \
       "cc_counts_24R8.txt" )


featureCounts \
-T 4 -O -C -p -s 2 -t exon -g gene_id \
-a /cluster/work/users/magdalena/RNA/5_hisat_alignment/genome_index/ccar_annotation.gtf \
-o /cluster/work/users/magdalena/RNA/6_featureCounts/single/${output[$SLURM_ARRAY_TASK_ID]}\
 /cluster/work/users/magdalena/RNA/5_hisat_alignment/aligned_reads_bam/${input[$SLURM_ARRAY_TASK_ID]}

#T: number of threads 
#O: Assign reads to all their overlapping meta-features (or features if -f is specified).
#C: Doesn't count read pairs that have their two ends mapping to different chromosomes or same chromosome, but different strands.
#p: paired end data 
#t: 
#g: 



echo finished featureCounts

# to close everything 
ml purge 










