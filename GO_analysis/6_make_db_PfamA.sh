#!/bin/bash

#!/bin/bash

#SBATCH --account=nn8014k
#SBATCH --job-name=HMMER_makedb_cc
#SBATCH --time=10:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

# load the needed modules
module load HMMER/3.3.2-gompi-2022b


# change directory to the program script 
cd /cluster/work/users/magdalena/GO_analysis/5_protein_family_search/


## HMMER was used, Pfam-A (01-Nov-2023; 21K entries)
#----------------------------------------------------------------------------
#		prepare pfam database(on saga)
#----------------------------------------------------------------------------

hmmpress Pfam-A.hmm
