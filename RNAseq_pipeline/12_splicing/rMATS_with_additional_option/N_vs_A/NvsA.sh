#!/bin/bash
#SBATCH --account=nn8014k
#SBATCH --job-name=rmats
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16

export APPTAINER_BIND="${PWD}:/opt/uio"
export APPTAINER_CACHEDIR=$USERWORK/.apptainer
export APPTAINER_TMPDIR=$USERWORK/.apptainer

echo "Running rMATS"

singularity exec rmats_4.3.0--py311hf2f0b74_5.sif bash -c "cd /opt/uio && rmats.py --b1 b1_N_vs_A.txt --b2 b2_N_vs_A.txt --gtf carcar_annotation_v5.gtf -t paired --readLength 150 --libType fr-firststrand --variable-read-length --nthread 16 --od ./output_N_vs_A --tmp ./tmp_N_vs_A"

echo "Finished rMATS"
