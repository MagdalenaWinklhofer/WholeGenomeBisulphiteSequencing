# Instructions and Workflow



## 1 Data import 
On the 2023_10_23 I received the final RNA sequencing data. I copied them on nird (for a untouched copy) and on saga (for w orking copy of the files) with the command: `wget --user=winklhofer-rna1 --password=rna1 https://hts-nonsecure.web.sigma2.no/231020_A01447.B.Project_Winklhofer-RNA1-2023-08-30/231020_A01447.B.Project_Winklhofer-RNA1-2023-08-30.tar .`. 

## 2 Unpack data 
The sequencing files were stored in the `/cluster/work/users/magdalena/RNA` directory. Since they were packed as a `tar` file. I unpacked them with the following command: `tar -xzvf yourfile.tar.gz`

## 3 Quality assessment of the raw RNA reads 
### Needed programs: FastQC
#### Installation: 
`FastQC` is a module on saga and does not need to be installed (just loaded). 

I performed a FASTQC run before and after trimming to compare the read quality (script: `3_fastqc_before_trimming.sh`). Here I used all fastq files (R1&R2) as input and let the script run without any additional settings. 

#### Checklist: 
If the quality of the reads do not look sufficient hard clipping should only be considered if needed due to low mapping efficiency!!!


## 4 Trimming of reads 
### Needed programs: Trim_Galore
#### Installation:  
`Trim_Galore` is a module on saga and does not need to be installed (just loaded).  

For the test dataset the data were test trimmed, but the trimmed data was not used for the alignment.  

For the full RNA sequencing the `4_trimgalore.sh` script was used to trim the sequences. I set as input the forward and reverse sequence (R1&R2) and set the setting to be `--paired`. The sequences were trimmed, if the quality went below the quality threshold of 20. After the trimming was perfomred I ran another round of fastqc to compare the quality of the sequences before and after. 

### 4.1 Quality assessment after trimming 
### Needed programs: Trim_Galore and FastQC
#### Installation:
The test trimmed data were quality checked, in the same script as they were trimmed `trimgalore.sh`. 

For the dataset (RNAseq 2023) I used the trimmed data for the alignment. Here the adapter were removed, but the quality of the reads was still a bit low at the beginning of the reads. Since Hisat2 perfomres soft clipping, I first aligned the reads and checked the alignment efficiency. Due to the fact that the alignment efficiency overall was not lower that 95% in all samples, I did not perform any soft clipping. 


## 5 - 7 Alignment of the trimmed reads 
### Needed programs: HISAT2
#### Installation: 
`HISAT2` is a module on saga and can be loaded. I ran the script `6_hisat_alignment.sh` on 4 cores in parallel. I printed out summary files to each samples. The option `reorder` was used to garantee that the SAM files were printed out in the same order as the reads in the input file.  
For all samples the mapping efficiency overall was above 95%, which is a very good result. 


Additionally, `SAMtools` was loaded to convert the alignment output (.sam) file into a (.bam) file. 

Procedure perfromed: 
- genome index 1: 11.04.2024
- genome_index 2: 11.04.2024
- alignment: 11.04.2024 (sam) 
- conversion to bam: 11.04.2024


## 8 Quantification of the mapped reads 
### Needed programs: featureCount
#### Installation 
The program was not installed. The module **Subread/2.0.3-GCC-11.2.0** was loaded in saga, which contains all needed comands, like **featureCounts**. 

I used the individual BAM files as input to create the feature count txt file for each sample. The feature was `geneid`. The created output was `cc_counts*.txt`, that was downloaded. 

NOTE: the `multiple` script is not needed for this investigation!

**Procedure perfromed: 11.04.2024**

## 9 Create Gene Counts Matrix (ubuntu)
### Needed programs: Python (with the kernel: rnaseq)
#### Installation: 
I created a conda environment `rnaseq` I which I could use the `HtsAna` function. I imported all the single `cc_counts*.txt` files and created a `gene_matrix_counts.csv` file. Additionally, I also created a table containing all the sample information (`sample_info.csv`). 
**Procedure perfromed: 03.06.2024**

## 10 Differentially Expressed Genes 
### Needed programs: R Studio 
#### Installation
The program **RStudio** can be downloaded and installed from the university software center. In was installed locally on my computer. I loaded the needed libraries (**DESeq2, tidyverse, airway**) and imported the data (`gene_matrix_counts.csv`, `sampl_info.csv`). I made sure that the column data and the row data of both dataframes were named the same and in the same order. Then I constructed a DESeqDataSet object. I filtered that object to only keep rows that have at least 10 reads. Further I set 'normoxia' as the base (factor) level. Afterwards, I ran the DEseq (differentially expressed gene) analysis. At the end I exported the three comparisons as csv files. 

**Procedure perfromed: 03.06.2024**

## 11 Identification of DEG 

To identify the DEGs i imported the output from Rstudio (`comp_anoxia_normoxia.csv`, `comp_reoxygenation_normoxia.csv`, `comp_anoxia_reoxygenation.csv`) and removed the rows that contained NA in the columns 'padj' and 'log2FoldChange'. Afterwards, I split the df in up and down regualted genes and create a dict for plotting. After ple plot is created I export the deg_* dataframes that are 'padj' <= 0.05. Those exported df are needed later for the correlation with DMRs. 





# NOTE: 
