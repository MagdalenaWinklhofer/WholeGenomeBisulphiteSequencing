# WGBS 

## Storage of the raw data 
The raw data were stored downloaded with `wget LINK_TO_FILE --user=USERNAME --password=PASSWORD`to NIRD as untouched backup in the directory: `projects/NS8014kk/data/carassius/2023_WGBS`. 

--------------------------------

## Data assessment:  
The data were unpacked (`tar -xvf XXX.tar`) on SAGA in the directory: `/cluster/work/users/magdalena/DNA` since the dataset is very large and the work directory has unlimited file storage and is backed up for four weeks. Tha anylsis was also performed here but the script files, slurm ouput and backups were stored on SAGA in the directory: `/cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/`. 

**General Sequence Information**: 
- The sequences are **paired end** (R1, R2).
- The sequences have an untrimmed average length of **150 bp** and were sequenced using the Illumina. 
- used **genome** file: created by Laura `ccar_genome_v1_262scaffolds_masked.fasta`
- used **annotation** file: created by Sjannie and copied from `/cluster/projects/nn8014k/ccar_latest_annotation/ccar_v1_262scaffolds_annotation_v4_pasa_agatfixed_frame.gtf`and renamed to `ccar_annotation.gtf`.  

## 1 Merge datasets (20.02.2024)
Since we first performed a test sequencing run (`230526_A01447.A.Project_Winklhofer-Libs1-2023-05-11`; 66GB) and after that the full sequencing of the samples in two parts (`230901_A01447.A.Project_Winklhofer-Libs1-2023-05-11`; 368GB, `240216_A01447.B.Project_Winklhofer-Libs1-2023-05-11.tar`; 423GB) the fastq files were merged to keep as much data as possible. Merging was performed with the `cat` command (appends reads to the original file). For more detailed information consult the script `/cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/1_merge_fastq.sh`. 

The slurm ouput contains the information of how many lines the individual sequencing attempts contained and how many lines the merged file contained. I checked all R1 and R1 merged files and they number of lines fit for all samples. With that I concluded that the merging step was successful and moved on to assess the quality with FASTQC and to trim off tha adapter and low quality reads with TrimGalore (section 2 and 3). 


## 2 Quality assessment (20.02.2024)
In the data we received from the **Norwegian Sequencing Center** they included a FASTQC analysis and added the results as PDF files. 

To get a more detailed look at the data quality I performed my own fastqc analysis to assess the reads before (`fastqc.sh`) and after trimming (`trimgalore.sh`). During this step the total number of reads that were analysed before trimming should be noted and compared with the total number of reads after timming (&rarr; they should be the same).



## 3 Trimming: quality based trimming and adapter removal (21.02.2024)
Used module: `Trim_Galore/0.6.10-GCCcore-11.2.0` 

### 3.1Trimgalore settings:  
I ran the shell script on four CPU's (`--cores 4`). The reads are paired end (`--paired`). If the quality assessment determined a value below the threshold of 20 (Phred: `--quality 20`) the reads were discarded and not included in the alignment process. The Phred indicates that 1/100 bases is incorrect. Adapter removal focuses on the "the overexpressed sequences" as an indicator for the presence of adapter contamination. TrimGalore detects those and removes them. If the quality and adapter trimming clipped the reads below a length of 20 bp's (`-- length 20`) the reads were discarded. After each trimming a fastqc quality assessment was performed (`--fastqc`). In line with the recommendations of Bismark for the libaray type of Zymo Pico Methyl kit (http://felixkrueger.github.io/Bismark/bismark/library_types/#zymo-pico-methyl-seq) 10 bp's from the 5' and the 3' end were clipped (`--clip_R1 10 --clip_r2 10 --three_prime_clip_R1 10 --three_prime_clip_R2 10`). The output was saved in the directory: `/cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/3_fastqc_after_trimming`. 


### 3.1 Check pre- and post-trimming fastqc  
I perfomred a Fastqc before and after the trimming and downloaded the `html`file **before** and **after** trimming (using sftp in ubuntu). They both can be opened in the browser and compared. The adapter sequences should be gone after trimming and under **overexpressed sequences** nothing should come up. 
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



## 4 Alignment - Bismark 

All alignments with **Bismark** were run in the `--non_directional` mode (see recommendations http://felixkrueger.github.io/Bismark/bismark/library_types/#zymo-pico-methyl-seq). 


### 4.1 Installation:
The alignment program **bismark** was installed with a tar file in the directory `/.program_bismark/`. The program needs Bowtie and Samtools as dependencies to be working correctly, hence the saga modules `Bowtie2/2.4.5-GCC-11.3.0` and `SAMtools/1.16.1-GCC-11.3.0` need to be loaded. Pay attention that both **compilers** are compatibale (can lead to errors otherwise). 

### 4.2 Genome preparation (Bowtie)  (21.02.2024)
The genome preparation was done, to be able to use the Bowtie index for the alignment. For this step the genome must be indexed accordingly. With the full sequencing the genome version (`ccar_genome_v1_262scaffolds_masked.fasta`) was used for indexing.  

### 4.3 Alignment (Bowtie):  
Here a reference genome and alignment parameters need to be specified. Bismark will produce a combined alignment output (default:BAM format) as well as a run statistics report.

#### 4.3.1 Alignment "--min_score" (22.02.2024 - 26.02.2024)
The following setting were chosen: 
- **parallel**: the script is run on 8 cpus in parallel 
- **un**: reads that could not be aligned are written into an `_unmapped_reads.fq.gz` output
- **non-directional**: The sequencing library was constructed in a non strand-specific manner, alignments to all four bisulfite strands (OT, OB, CTOT, CTOB) will be reported. 
- **score_min L,0,-0.4**: Sets a function governing the minimum alignment score needed for an alignment to be considered "valid"


| Run complete | Sample  | Mapping efficiency   | Commend  |
|---|---|---|---|
| Y  |  N1 |  52.9% |  0: 10768462_0|
| Y  |  N2 | 52.2% |  1: 10768462_1|
| Y  |  N3 |  53.7% |  2: 10768462_2|
| Y  |  N7 |  45.8% |  3: 10768462_3|
| Y  |  A1 | 52.0%  |  4: 10579018_4 |
| Y  |  A2 | 50.7%  |  5 10579018_5 |
| Y  |  A4 |  49.7% |  6: 10775892_6 |
| Y  |  A7 |  47.9% |  7: 10775892_7 |
| Y  |  24R2 | 50.8%  |8: 10579018_8  |
| Y  |  24R3 | 50.3%  |9: 10579018_9   |
| Y  |  24R7 | 47.6%  |10:  10579018_10  |
| Y  |  24R8 | 45.1%  |11:  10579018_10  |

Y= yes ; N= no



#### 4.3.2 Alignment "--local" (04.03.2024 - 12.03.2024)

The following setting were chosen: 
- **parallel**: the script is run on 8 cpus in parallel 
- **non-directional**: The sequencing library was constructed in a non strand-specific manner, alignments to all four bisulfite strands (OT, OB, CTOT, CTOB) will be reported. 
- **local**: here it is not required that the entire read aligns from one end to the other. Rather, some characters may be omitted (“soft-clipped”) from the ends in order to achieve the greatest possible alignment score. 

| Run complete | Sample  | Mapping efficiency   | Commend  |
|---|---|---|---|
| Y  |  N1 | 75.9%  | 10863933_0  |
| Y  |  N2 | 76.6%  | 10863933_1  |
| Y  |  N3 | 73.4%  | 10863933_2  |
| Y  |  N7 | 72.3%  | 10863933_3  |
| Y  |  A1 | 76.9%  | 10863933_4  |
| N |  A2 |   |   |
| N  |  A4 |   |   |
| N  |  A7 |   |   |
| N  |  24R2 |   |   |
| N  |  24R3 |   |   |
| N  |  24R7 |   |   |
| N  |  24R8 |   |   |

**The others were not started since we run out of hours**

Y= yes ; N= no

#### 4.3.2 Alignment "BWA-METH" (13.03.2024 - .03.2024)

I first indexed the genome and then ran an alignment. BWA-METH performs softclipping, but we get a high alignment efficiency. 

| Run complete | Sample  | Mapping efficiency   | Commend  |
|---|---|---|---|
| N  |  N1 |   | 10925611_0  |
| N  |  N2 |   | 10925611_1  |
| N  |  N3 |   | 10925611_2  |
| N  |  N7 |   | 10925611_3  |
| N  |  A1 |   | 10925611_4  |
| N |  A2 |   |  10925611_5 |
| N  |  A4 |   |  10925611_6 |
| N  |  A7 |   |  10925611_7 |
| N  |  24R2 |   | 10925611_8  |
| N  |  24R3 |   | 10925611_9  |
| N  |  24R7 |   | 10925611_10  |
| N  |  24R8 |   | 10925611_11  |

Y= yes ; N= no




## 5A) DMR identification

To identify the differentially methylated regions (DMR) between the conditions normoxia, anoxia, and reoxygenation I installe the program `methylpy` in an anonconda environment (`methylpy_env`). Since I have not used that program to align the reads to the genome, I first have to index my genome (done with the script: `1_methylpy_index`). To take my deduplicated .bam files as input to the DMR script, they first have to be sorted and indexed (done with the script: `3_methylpy_index_bam.sh`). For that I have copied the whole 116GB of deduplicated bam files (in the work directory) in the same directory as the genome index. After sorting and indexing of the bam files. I listed the in space seperated lists and ran three `4_methylpy_DMR.sh` scripts to compare the three conditions (normoxia vs. anoxia, normoxia vs. reoxygenation, anoxia vs. reoxygenation). The result files were downloaded and the significant (p-value < 0.05) filtered in a python script. 

The script creates two output file types **DMS** (differentially methylated sites) and **DMR** (differentially methylated regions): 

 - DMS columns: 
 1) Chromosomal position 
 2) start position 
 3) stop position 
 4) sequence contect (3-based) 
 5) strand 
 6) p-value from the differential methylation test (can be ignored)

- DMR columns: 
1) Chromosome position 
2) start position 
3) stop position 
4) number of DMSs within the DMR (*if there is only one DMS in a DMR, the DMR will be one base pair long.* **Recommendation: only consider DMR with at least 4 DMS**)


### 5A) DMR identification (METHYLSCORE)
**Installation**: 
1) Move the directory: `/cluster/work/users/magdalena/DMR`
2) Clone the git repository of the program MethylScore: ` https://github.com/Computomics/MethylScore.git`
3) Install the program Nextflow: `https://www.nextflow.io/docs/latest/getstarted.html#installation` with the following command: `wget -qO- https://get.nextflow.io | bash`
4) Create a singularity image: `singularity build methylscore_0.2.sif docker://quay.io/beckerlab/methylscore:0.2`
5) move to the directory: `MethylScore/conf/` and create the file `slurm.config` (a copy of the file that needs to be created is stored as a backup in the directory: `/cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/14_DMR`)
6) move to the directory: `MethylScore/` and alter the file `nextflow.config` (a copy of the file that needs to be created is stored as a backup in the directory: `/cluster/projects/nn8014k/magdalena/script_WGBS/DNAseq_pipeline/14_DMR`)

--> For more information check the WGBS folder in magdalena's outlook program. 

**General Information**:   
The program start with the .bam file (aligned by bismark). I copied them from NIRD (--minscore). 

**Run**:   
For the run including the `working.genome.masked.262contigs.fasta` and all aligned 12 samples (aligned with Bismark --minscore) I copied the genome file into the MethylScore directory, but kept the .bam files in an alignment directory: `/cluster/work/users/magdalena/DMR/alignments`. I stated the absolute path to navigate the program to each .bam sample file. 






### 6) Crossreferencing DMR and DEG
This was done with a python script I wrote. I is based on the idea, that the DMR are 1-based. That means they have a specififc number. The differentially expressed genes (DEG) will give back a area (range) of bases (the whole gene). I checked if the DMR is between the bourders of the DEG. 


#### 6.1) Prefiltering the allc_condition files

The allc_normoxia.tsv, allc_anoxia.tsv and allc_reoxygenation.tsv file were to big to be read into my memory, hence I performed a prefiltering step with the `6_filter_merged_output.py` that was incooperated into the `6_filter_merged_output.sh` script. Here I only consider the 1,4, and 5th column. 

The allc_*.tsv file contains the following columns: 
1) Chromosome 
2) position (1-based) 
3) strand 
4) sequence context (3-based) 
5) counts of reads supporting methylation 
6) read coverage 
7) indicator of significant methylation (1 if no test is perfomred) 









