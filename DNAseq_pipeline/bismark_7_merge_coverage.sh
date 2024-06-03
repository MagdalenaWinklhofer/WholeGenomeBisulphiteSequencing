#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Bismark_merge_cc
#SBATCH --time=05:00:00
#SBATCH --mem-per-cpu=12G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2

# load the needed modules


# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/projects/nn8014k/magdalena/script_WGBS/bismark_merge/coverage/

# Commands for the program (alignment of the reads to the genome)

#./merge_coverage_files_ARGV.py \
#/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/N1-D14-1.gz.bismark.cov.gz \
#/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/N2-D15-1.gz.bismark.cov.gz \
#/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/N3-D16-2.gz.bismark.cov.gz \
#/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/N7-D36-1.gz.bismark.cov.gz \

#./merge_coverage_files_ARGV.py \
#/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/A1-D17-1.gz.bismark.cov.gz \
#/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/A2-D18-1.gz.bismark.cov.gz \
#/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/A4-D26-2.gz.bismark.cov.gz \
#/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/A7-D37-1.gz.bismark.cov.gz \


./merge_coverage_files_ARGV.py \
/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/24R2-D21-2.gz.bismark.cov.gz \
/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/24R3-D22-2.gz.bismark.cov.gz \
/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/24R7-D38-1.gz.bismark.cov.gz \
/cluster/projects/nn8014k/magdalena/script_WGBS/bismark_6bedGraph/24R8-D39-1.gz.bismark.cov.gz \


# to close everything 
ml purge 











