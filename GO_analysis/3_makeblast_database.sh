#!/bin/bash

#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=Trinotate_makedb_cc
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

# load the needed modules
module load Anaconda3/2022.10
source ${EBROOTANACONDA3}/bin/activate
conda activate /cluster/projects/nn8014k/magdalena/conda_environments/trinotate


# change directory to the program script 
cd /cluster/work/users/magdalena/GO_analysis/2_blastx/


## Trinotate was used, Uniprot/Swissprot release 2019_09 (01-Nov-2023, UniProtKB/Swiss-Prot: 570,157 entries) 
#----------------------------------------------------------------------------
#		prepare swissprot database(on saga)
#----------------------------------------------------------------------------

makeblastdb -in uniprot_sprot.fasta -dbtype prot

