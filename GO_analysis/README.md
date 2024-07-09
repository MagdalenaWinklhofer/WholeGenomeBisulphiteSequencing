# General Information 

This file contains all the information related to the Gene Ontology enrichment analysis that I perfomred (28.06.2024). 

In prinziple the GO enrichment analysis test if a small subset shows an enrichment of GO terms compared to a background. 



# 1) Create a subset 

In my case the subset will be all the genes that were hit by one/more DMRs. 

To create the subset I created the script `1_filter_deg_for_dmr_geneids.ipynb` in which I imported the expression information off all genes. I used the geneids that were hit by DMRs to filter that df. I only kept the lines that corresponded to the gene ids that were hit ba a DMR. 

The created files are named: `goseq_[comparison_name].csv` and were downloaded from ubuntu to `C:\Users\magdaw\OneDrive - Universitetet i Oslo\Dokumente\Arbeit\Data\2022_WGBS\2023_08_WGBS_seq_data_analysis\2023_11_Gene_Onology_Enrichment_Analysis\02_GO_enrichment_analysis`. 


# 2) create gene length df 

To get the gene length of all geneids I imported the annotation into the `1_filter_deg_for_dmr_geneids.ipynb` script and calculated [stop] - [start], dropped all other column and saved it as csv. 

The created files are named: `gene_length.csv` and were downloaded from ubuntu to `C:\Users\magdaw\OneDrive - Universitetet i Oslo\Dokumente\Arbeit\Data\2022_WGBS\2023_08_WGBS_seq_data_analysis\2023_11_Gene_Onology_Enrichment_Analysis\02_GO_enrichment_analysis`.

# 3) Alter format of geneid_to_goterm df 

I imported the `gene_id_goterms_df_fullgenome.tsv` df that I got from Laura and altered the format and saved as txt file. 

The created files are named: `geneid_goterm.txt` and were downloaded from ubuntu to `C:\Users\magdaw\OneDrive - Universitetet i Oslo\Dokumente\Arbeit\Data\2022_WGBS\2023_08_WGBS_seq_data_analysis\2023_11_Gene_Onology_Enrichment_Analysis\02_GO_enrichment_analysis`.


# 4) total number of genes 

The input file is created by the `01_data_preparation` and imported as a df in the `1_filter_deg_for_dmr_geneids.ipynb` script. The df gets reformated and downloaded from ubuntu to `C:\Users\magdaw\OneDrive - Universitetet i Oslo\Dokumente\Arbeit\Data\2022_WGBS\2023_08_WGBS_seq_data_analysis\2023_11_Gene_Onology_Enrichment_Analysis\02_GO_enrichment_analysis`.