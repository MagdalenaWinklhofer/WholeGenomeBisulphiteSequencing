#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=defiant_cc
#SBATCH --time=01:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4

# activate the environment 
#module load Anaconda3/2022.10
#source ${EBROOTANACONDA3}/bin/activate
#conda activate /cluster/projects/nn8014k/magdalena/conda_environments/defiant/
#ml load R/4.2.2-foss-2022b

# show me the loaded modules in a list
ml list

# change directory to the program script 
cd /cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/defiant_diffmeth/

# Command of the program 
#defiant -c 10 -p 0.05,0.10 -L Normoxia,Anoxia -l comparison -i N1-D14-1.CpG_report.txt,N2-D15-1.CpG_report.txt,N3-D16-2.CpG_report.txt,N7-D36-1.CpG_report.txt A1-D17-1.CpG_report.txt,A2-D18-1.CpG_report.txt,A4-D26-2.CpG_report.txt,A7-D37-1.CpG_report.txt


/cluster/projects/nn8014k/magdalena/.program_defiant/defiant/defiant -c 10 -CpN 1,5,1 -p 0.05,0.15,0.05 -S 1,5,1 -L Normoxia,Anoxia -l comparison -i N1-D14-1.CpG_report.txt,N2-D15-1.CpG_report.txt,N3-D16-2.CpG_report.txt,N7-D36-1.CpG_report.txt A1-D17-1.CpG_report.txt,A2-D18-1.CpG_report.txt,A4-D26-2.CpG_report.txt,A7-D37-1.CpG_report.txt

/cluster/projects/nn8014k/magdalena/.program_defiant/defiant/defiant -c 10 -CpN 1,5,1 -p 0.05,0.15,0.05 -S 1,5,1 -L Normoxia,Reoxygenation -l comparison -i N1-D14-1.CpG_report.txt,N2-D15-1.CpG_report.txt,N3-D16-2.CpG_report.txt,N7-D36-1.CpG_report.txt R2-D21-2.CpG_report.txt,R3-D22-2.CpG_report.txt,R7-D38-1.CpG_report.txt,R8-D39-1.CpG_report.txt

/cluster/projects/nn8014k/magdalena/.program_defiant/defiant/defiant -c 10 -CpN 1,5,1 -p 0.05,0.15,0.05 -S 1,5,1 -L Anoxia,Reoxygenation -l comparison -i R2-D21-2.CpG_report.txt,R3-D22-2.CpG_report.txt,R7-D38-1.CpG_report.txt,R8-D39-1.CpG_report.txt A1-D17-1.CpG_report.txt,A2-D18-1.CpG_report.txt,A4-D26-2.CpG_report.txt,A7-D37-1.CpG_report.txt


# c: minimum coverage 
# a: annotation
# p: p-value 
# P: minimum percentage of methylation difference is set to 10% on default 
# v: print p-value for each DMR (default:Holm)


# o: overwrite existing files if present 

# -a ccar_annotation.gtf 

# try -paired and see the difference. try v option

#-fdr 'Bonferroni'
# -c 1,10,1 -p 0.01,0.05 -cpu 4 

# try out plot_results.pl script (depends on LaTex and GNUPlot) to create a tidy report on how each parameter influences the number of DMRs found 

# close all modules
ml purge 