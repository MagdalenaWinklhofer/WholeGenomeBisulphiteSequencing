

#----------------------------------------------------------------------------
#		generate report and files using swissprot and goldfish
#----------------------------------------------------------------------------
module load Perl/5.28.0-GCCcore-7.3.0

## Annotation report (saga, start 270120 10.51, finish 14.12):
/cluster/home/sjannies/Trinotate-v3.2.0/Trinotate Trinotate.sqlite report -E 1e-7 > merged_gg_final_annotation_report_e07_jan2020_RAW.xls 

## removing empty rows (from Brian Haas) (270120):
cat merged_gg_final_annotation_report_e07_jan2020_RAW.xls | perl -lane '@x = @F[2..$#F]; if (grep {$_ ne "." } @x) { print;}'  >  merged_gg_final_annotation_report_e07_jan2020_no_empty.xls

## make GO file for genes (270120):
/cluster/home/sjannies/Trinotate-v3.2.0/util/extract_GO_assignments_from_Trinotate_xls.pl --Trinotate_xls merged_gg_final_annotation_report_e07_jan2020_RAW.xls  -G --include_ancestral_terms > merged_gg_final_gene_GO_annotations_jan2020.txt

## modify GO file for genes to bingo format, with one GO term per line, first making empty cells (270120):
sed 's/,GO:/\n\t/g' < merged_gg_final_gene_GO_annotations_jan2020.txt > merged_gg_final_gene_GO_annotations_jan2020_bingo.txt
sed -i 's/GO://g' merged_gg_final_gene_GO_annotations_jan2020_bingo.txt
 
## use the package 'zoo' to replace empty cells with previous value (270120):
module load R/3.5.1-intel-2018b  ### R is used in the script
module load R-bundle-Bioconductor/3.8-intel-2018b-R-3.5.1
R
library(zoo)
go_bingo=read.table("merged_gg_final_gene_GO_annotations_jan2020_bingo.txt", stringsAsFactors=F, fill = TRUE, sep="\t")
go_bingo$V1[go_bingo$V1==""]=NA
go_bingo$V1=na.locf(go_bingo$V1)
write.table(go_bingo, "merged_gg_final_gene_GO_annotations_jan2020_bingo_format.txt", col.names = FALSE, row.names = FALSE, quote=FALSE, sep="\t")
q()
## add "(species=Carassius carassius)(type=Full)(curator=GO)" to the first line using nano, save as merged_gg_final_gene_GO_annotations_jan2020_bingo_format.txt (270120)
## replace tabs with '=':
nano merged_gg_final_gene_GO_annotations_jan2020_bingo_format.txt
sed -i 's/\t/=/g' merged_gg_final_gene_GO_annotations_jan2020_bingo_format.txt
rm merged_gg_final_gene_GO_annotations_jan2020_bingo.txt

# get descriptions from goldfish rna and proteins

grep ">" /cluster/home/sjannies/blast_databases/goldfish_protein.faa | sed -r 's/>//1' > goldfish_protein.faa.descriptions
sed -i -r 's/ /\t/1' goldfish_protein.faa.descriptions
sed -i -r 's/ \[.*/\t/1' goldfish_protein.faa.descriptions

grep ">" ../../blast_databases/goldfish_GCF_003368295.1_ASM336829v1_rna.fa | sed -r 's/>//1' > goldfish_rna.fa.descriptions
sed -i -r 's/ref\|//g' goldfish_rna.fa.descriptions
sed -i -r 's/\| PREDICTED: Carassius auratus /\t/g' goldfish_rna.fa.descriptions
