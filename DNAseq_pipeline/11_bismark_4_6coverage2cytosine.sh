#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Bismark_coverage2cytosine_cc
#SBATCH --time=23:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=8
#SBATCH --array=0-11


# load the needed modules
ml load Bowtie2/2.4.5-GCC-11.3.0
ml load SAMtools/1.16.1-GCC-11.3.0

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/work/users/magdalena/9_bismark_coverage2cytosine/

# Commands for the program (alignment of the reads to the genome)
input=("N1-D14-1.bismark.cov.gz" \
       "N2-D15-1.bismark.cov.gz" \
       "N3-D16-2.bismark.cov.gz" \
       "N7-D36-1.bismark.cov.gz" \
       "A1-D17-1.bismark.cov.gz" \
       "A2-D18-1.bismark.cov.gz" \
       "A4-D26-2.bismark.cov.gz" \
       "A7-D37-1.bismark.cov.gz" \
       "24R2-D21-2.bismark.cov.gz" \
       "24R3-D22-2.bismark.cov.gz" \
       "24R7-D38-1.bismark.cov.gz" \
       "24R8-D39-1.bismark.cov.gz" )

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

/cluster/projects/nn8014k/magdalena/.program_bismark/Bismark-0.24.1/coverage2cytosine \
 /cluster/work/users/magdalena/8_bismark_bedGraph/${input[$SLURM_ARRAY_TASK_ID]} \
 --genome_folder /cluster/projects/nn8014k/magdalena/script_WGBS/4_bismark_1index/ \
 --output ${output[SLURM_ARRAY_TASK_ID]} \
 --dir /cluster/work/users/magdalena/9_bismark_coverage2cytosine/


# to close everything 
ml purge 











