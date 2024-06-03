#----------------------------------------------------------------------------
#		load sqlite
#----------------------------------------------------------------------------

srun --ntasks=2 --mem-per-cpu=4G --time=03:00:00 --account=nn8014k --pty bash -i
module load Perl/5.28.0-GCCcore-7.3.0

# copy fresh boilerplate (130320):
rsync /cluster/home/sjannies/Trinotate-v3.2.0/Trinotate.sqlite .

# cop all the nessacary files into the following directory 
# needed files: blastx output (merged), blastp output (merged), pfamscan output (merged) 
cd /cluster/work/users/magdalena/GO_analysis/6_trinotate_report/


## load protein hits swissprot (130320):
/cluster/home/sjannies/Trinotate-v3.2.0/Trinotate Trinotate.sqlite LOAD_swissprot_blastp blastp_swissprot_e07_merged_gg_final2.outfmt6 >> sqlite2.log 2>&1

## load transcript hits swissprot (130320):
/cluster/home/sjannies/Trinotate-v3.2.0/Trinotate Trinotate.sqlite LOAD_swissprot_blastx blastx_swissprot_e07_merged_gg_final.outfmt6 >> sqlite2.log 2>&1

## Load Pfam domain entries, hmmscan results (1303020):
/cluster/home/sjannies/Trinotate-v3.2.0/Trinotate Trinotate.sqlite LOAD_pfam hmmscan_merged_gg_final_PfamA.out >> sqlite2.log 2>&1
