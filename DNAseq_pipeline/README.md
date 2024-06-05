# WGBS 

## Storage of the raw data 
The raw data were stored downloaded with `wget LINK_TO_FILE --user=USERNAME --password=PASSWORD`to NIRD as untouched backup in the directory: `projects/NS8014kk/data/carassius/2023_WGBS`. 

--------------------------------

## Data assessment:  
The data were unpacked (`tar -xvf XXX.tar`) on SAGA in the directory: `/cluster/work/users/magdalena/DNA` since the dataset is very large and the work directory has unlimited file storage and is backed up for four weeks. The anylsis was also performed here but the script files, slurm ouput and backups were stored on SAGA in the directory: `/cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/`. 

**General Sequence Information**: 
- The sequences are **paired end** (R1, R2).
- The sequences have an untrimmed average length of **150 bp** and were sequenced using the Illumina. 
- used **genome** file: created by Laura `ccar_genome_v1_262scaffolds_masked.fasta`
- used **annotation** file: created by Sjannie and copied from `/cluster/projects/nn8014k/ccar_latest_annotation/ccar_v1_262scaffolds_annotation_v4_pasa_agatfixed_frame.gtf`and renamed to `ccar_annotation.gtf`.  

## 1 Merge datasets (20.02.2024)
Since we first performed a test sequencing run (`230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11`; 66GB) and after that the full sequencing of the samples in two parts (`230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11`; 368GB, `240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11.tar`; 423GB) the fastq files were merged to keep as much data as possible. Merging was performed with the `cat` command (appends reads to the original file). For more detailed information consult the script `/cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/1_merge_fastq.sh`. 

The slurm ouput contains the information of how many lines the individual sequencing attempts contained and how many lines the merged file contained. I checked all R1 and R1 merged files and they number of lines fit for all samples. With that I concluded that the merging step was successful and moved on to assess the quality with FASTQC and to trim off tha adapter and low quality reads with TrimGalore (section 2 and 3). 


## 2 Quality assessment (20.02.2024)
In the data we received from the **Norwegian Sequencing Center** they included a FASTQC analysis and added the results as PDF files. 

To get a more detailed look at the data quality I performed my own fastqc analysis to assess the reads before (`fastqc.sh`) and after trimming (`trimgalore.sh`). During this step the total number of reads that were analysed before trimming should be noted and compared with the total number of reads after timming (&rarr; they should be the same).



## 3 Trimming: quality based trimming and adapter removal (21.02.2024)
Used module: `Trim_Galore/0.6.10-GCCcore-11.2.0` 

### 3.1Trimgalore settings:  
I ran the shell script on four CPU's (`--cores 4`). The reads are paired end (`--paired`). If the quality assessment determined a value below the threshold of 20 (Phred: `--quality 20`) the reads were discarded and not included in the alignment process. The Phred indicates that 1/100 bases is incorrect. Adapter removal focuses on the "the overexpressed sequences" as an indicator for the presence of adapter contamination. TrimGalore detects those and removes them. If the quality and adapter trimming clipped the reads below a length of 20 bp's (`-- length 20`) the reads were discarded. After each trimming a fastqc quality assessment was performed (`--fastqc`). The output was saved in the directory: `/cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/3_fastqc_after_trimming`. 


### 3.1 Check pre- and post-trimming fastqc  
I performed a Fastqc before and after the trimming and downloaded the `html`file **before** and **after** trimming (using sftp in ubuntu). They both can be opened in the browser and compared. The adapter sequences should be gone after trimming and under **overexpressed sequences** nothing should come up. 
- **adapter detection graph**: all locked good 
- **Per base sequence content**: with WGBS libraries this often comes up as a warning, since the C content is lowered through the bisulphite conversion; the discrepancy between the bases should be as small as possible (&rarr; could be a reason for low mapping efficiency in R1 or R2); The plot looks a bit distorted in the 5' end of the sequence &rarr; this is expected in a WGBS libraries and nothing to worry about (was double checked by Zymo bioinformatician) 


| Run complete | Sample  | R1  | R2  | Commend  |
|---|---|---|---|---|
| Y  |  N1 |  OK |  OK |  - |
| Y  |  N2 |  OK |  OK |  - |
| Y  |  N3 |  OK |  OK |  - |
| Y  |  N7 |  OK |  OK |  - |
| Y  |  A1 |  OK |  OK |  - |
| Y  |  A2 |  OK | OK  | R1 & R2 could be cut 20 bp from 5'  |
| Y  |  A4 |  OK | OK  |  - |
| Y  |  A7 |  OK |  OK |  - |
| Y  |  24R2 |  OK | OK  |  - |
| Y  |  24R3 |  OK | OK  |  - |
| Y  |  24R7 |  OK | OK  |  - |
| Y  |  24R8 |  OK | OK  | R1 could cut 15 bp from 5'; R2 could cut 20 bp from 5'  |

Y= yes ; N= no


## 4 Alignment "BWA-METH" (13.03.2024 - 25.03.2024)

I first indexed the genome and then ran an alignment. BWA-METH performs softclipping, but we get a high alignment efficiency. 
To asses the mapping efficiency I ran the `bwamth_flagstat.sh` script. 

| Run complete | Sample  | Mapping efficiency   | Commend  |
|---|---|---|---|
| N  |  N1 | 93.90%  | slurm-11727410_0.out  |
| N  |  N2 |  93.13%  | slurm-11727410_1.out  |
| N  |  N3 | 95.29%  | slurm-11727410_2.out  |
| N  |  N7 | 91.00%   | slurm-11727410_3.out  |
| N  |  A1 |  95.52% | slurm-11727410_4.out  |
| N |  A2 |  96.55% |  slurm-11727410_5.out |
| N  |  A4 | 95.98%  |  slurm-11727410_6.out |
| N  |  A7 | 92.54% |  slurm-11727410_7.out |
| N  |  24R2 |  96.79% | slurm-11727410_8.out  |
| N  |  24R3 | 96.82%  | slurm-11727410_9.out  |
| N  |  24R7 |  95.47% | slurm-11727410_10.out  |
| N  |  24R8 |  96.47% | slurm-11727410_11.out  |

(NOTE: Since I lost the flagstat files I ran that script again on the 03.06.2024 to get the mapping efficiency)





## 5 DMR identification (METHYLSCORE) (finished: 31.05.2024)
**Installation**: 
1) Move the directory: `/cluster/work/users/magdalena/DMR`
2) Clone the git repository of the program MethylScore: ` https://github.com/Computomics/MethylScore.git`
3) Install the program Nextflow: `https://www.nextflow.io/docs/latest/getstarted.html#installation` with the following command: `wget -qO- https://get.nextflow.io | bash`
4) Create a singularity image: `singularity build methylscore_0.2.sif docker://quay.io/beckerlab/methylscore:0.2`
5) move to the directory: `MethylScore/conf/` and create the file `slurm.config` (a copy of the file that needs to be created is stored as a backup in the directory: `/cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/5_dmr_identification/Methylscore/Installation`)
6) move to the directory: `MethylScore/` and alter the file `nextflow.config` (a copy of the file that needs to be created is stored as a backup in the directory: `/cluster/projects/nn8014k/magdalena/WGBS/DNAseq_pipeline/5_dmr_identification/Methylscore/Installation`)

--> For more information check the WGBS folder in magdalena's outlook program. 

**General Information**:   
The program start with the .bam file (aligned by bwameth). I copied them from NIRD. 

**Run**:   
For the run : 
- each comparison got its own project direcoty (see scripts) 
- samplesheets: in the `/cluster/work/users/magdalena/DMR/data`
- the genome: `ccar_genome_v1_262scaffolds_masked.fasta` was stored in `/cluster/work/users/magdalena/DMR/data/`  
- all aligned 12 samples (aligned with bwameth): in the `/cluster/work/users/magdalena/DMR/alignment_bwa_meth` directory as .bam files  



## 6) Filtering of DMRsCG

The first filtering step is to exclude all the rows that do not have the same biological samples in clusters. Afterwards, I filter for that a minimum of 6 samples are represented in the cluster. To filter even further I only take the significantly differentially methylated DMRs. 

NOTE: For now I want to be more conservative in my approach, hence I stop after the second filter step. The file `2_filtered_min_6samples.txt` is copied and named after the coondition in the comparison for further analysis. 

## 7) Match DMRs to gene id's
To match the DMRs to genes I import the annotation and extract the gene and transcript id's. Since the current annotation does not include the untranslated regions/ promotors to a full capacity, I add 2000 bp before and after the start and stop of each gene. If a gene starts below 2000 bp the number is set to 0 (there can't be any negative bp). 


























## 6) Crossreferencing DMR and DEG
This was done with a python script I wrote. I is based on the idea, that the DMR are 1-based. That means they have a specififc number. The differentially expressed genes (DEG) will give back a area (range) of bases (the whole gene). I checked if the DMR is between the bourders of the DEG. 


### 6.1) Prefiltering the allc_condition files

The allc_normoxia.tsv, allc_anoxia.tsv and allc_reoxygenation.tsv file were to big to be read into my memory, hence I performed a prefiltering step with the `6_filter_merged_output.py` that was incooperated into the `6_filter_merged_output.sh` script. Here I only consider the 1,4, and 5th column. 

The allc_*.tsv file contains the following columns: 
1) Chromosome 
2) position (1-based) 
3) strand 
4) sequence context (3-based) 
5) counts of reads supporting methylation 
6) read coverage 
7) indicator of significant methylation (1 if no test is perfomred) 









