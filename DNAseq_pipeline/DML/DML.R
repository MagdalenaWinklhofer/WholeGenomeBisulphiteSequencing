#Investigate differentially methylated loci and regions of the WGBS data 

# set the location for the packages to be installed
.libPaths(c("/cluster/home/magdalena/R", .libPaths()))

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("DMRcaller")


# check whether the package can be loaded
library(BiocManager)
require(bsseq)
library(DMRcaller)
library(ggplot2)

#change working diretcory 
setwd("/cluster/work/users/magdalena/11_DML")
getwd()

## first read in methylation data.
#NORMOXIA
normoxia <- readBismarkPool(files=(c("/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/N1-D14-1.CpG_report.txt", 
                                     "/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/N2-D15-1.CpG_report.txt",
                                     "/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/N3-D16-2.CpG_report.txt",
                                     "/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/N7-D36-1.CpG_report.txt")))

#ANOXIA
anoxia <- readBismarkPool(files=c("/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/A1-D17-1.CpG_report.txt",
                                  "/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/A2-D18-1.CpG_report.txt",
                                  "/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/A4-D26-2.CpG_report.txt",
                                  "/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/A7-D37-1.CpG_report.txt"))

#REOXYGENATION
reoxygenation <- readBismarkPool(files=c("/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/24R2-D21-2.CpG_report.txt",
                                         "/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/24R3-D22-2.CpG_report.txt",
                                         "/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/24R7-D38-1.CpG_report.txt",
                                         "/cluster/projects/nn8014k/magdalena/script_WGBS/11_bismark_7coverage/testseq/24R8-D39-1.CpG_report.txt"))

#QUALITY CONTROL
#Coverage of data

#computeMethylationDataCoverage()
#region=NULL - coverage is computed genome-wide
#breaks=NULL - no threshold limit was given when computing the coverage 
#proportion=TRUE - a proportion of the counts is calculated (not the raw read counts) 

breaks <- c(1,2,4,5,7,10,12,15)

#NORMOXIA
n_coverage <- computeMethylationDataCoverage(normoxia, regions = NULL,
                                             context = "CG", breaks = breaks, proportion = TRUE)
#ANOXIA 
a_coverage <- computeMethylationDataCoverage(anoxia, regions = NULL,
                                             context = "CG", breaks = breaks, proportion = TRUE)
#REOXYGENATION
r_coverage <- computeMethylationDataCoverage(reoxygenation, regions = NULL,
                                             context = "CG", breaks = breaks, proportion = TRUE)

#plot the methylation coverage
# normoxia vs. anoxia 
tiff(file="normoxia_anoxia.tiff", width=6, height=4, units="in", res=600)
plotMethylationDataCoverage(normoxia, anoxia, breaks = breaks, region = NULL, conditionsNames = c("normoxia", "anoxia"), context = "CG", proportion = TRUE)
dev.off()

# normoxia vs. reoxygenation
tiff(file="normoxia_reoxygenation.tiff", width=6, height=4, units="in", res=600)
plotMethylationDataCoverage(normoxia, reoxygenation, breaks = breaks, region = NULL, conditionsNames = c("normoxia", "reoxygenation"), context = "CG", proportion = TRUE)
dev.off()

# anoxia vs. reoxygenation 
tiff(file="anoxia_reoxygenation.tiff", width=6, height=4, units="in", res=600)
plotMethylationDataCoverage(anoxia, reoxygenation, breaks = breaks, region = NULL, conditionsNames = c("anoxia", "reoxygenation"), context = "CG", proportion = TRUE)
dev.off()


#DMR ANALYSIS

#NEIGHBOURHOOD
# normoxia vs anoxia 
NB_NvsA <- computeDMRs(normoxia, anoxia, regions = NULL, context = "CG", method = "neighbourhood", 
                       test = "score", pValueThreshold = 0.01, minCytosinesCount = 4, minProportionDifference = 0.4, 
                       minGap = 200, minSize = 50, minReadsPerCytosine = 4, cores = 1)

write.table(NB_NvsA, "DMR_NB_NvsA.txt", sep = "\t", row.names = FALSE)

# normoxia vs reoxygenation
NB_NvsR <- computeDMRs(normoxia, reoxygenation, regions = NULL, context = "CG", method = "neighbourhood", 
                       test = "score", pValueThreshold = 0.01, minCytosinesCount = 4, minProportionDifference = 0.4, 
                       minGap = 200, minSize = 50, minReadsPerCytosine = 4, cores = 1)

write.table(NB_NvsR, "DMR_NB_NvsR.txt", sep = "\t", row.names = FALSE)

# anoxia vs reoxygenation
NB_AvsR <- computeDMRs(anoxia, reoxygenation, regions = NULL, context = "CG", method = "neighbourhood", 
                      test = "score", pValueThreshold = 0.01, minCytosinesCount = 4, minProportionDifference = 0.4, 
                      minGap = 200, minSize = 50, minReadsPerCytosine = 4, cores = 1)

write.table(NB_AvsR, "DMR_NB_AvsR.txt", sep = "\t", row.names = FALSE)


#BINS
# normoxia vs anoxia 
B_NvsA <- computeDMRs(normoxia, anoxia, regions = NULL, context = "CG", method = "bins", binSize = 100, test = "score", 
                      pValueThreshold = 0.01, minCytosinesCount = 4, minProportionDifference = 0.4, minGap = 200, minSize = 50, 
                      minReadsPerCytosine = 4, cores = 1)

write.table(B_NvsA, "DMR_B_NvsA.txt", sep = "\t", row.names = FALSE)

# normoxia vs reoxygenation
B_NvsR <- computeDMRs(normoxia, reoxygenation, regions = NULL, context = "CG", method = "bins", binSize = 100, test = "score", 
                      pValueThreshold = 0.01, minCytosinesCount = 4, minProportionDifference = 0.4, minGap = 200, minSize = 50, 
                      minReadsPerCytosine = 4, cores = 1)

write.table(B_NvsR, "DMR_B_NvsR.txt", sep = "\t", row.names = FALSE)

# anoxia vs reoxygenation
B_AvsR <- computeDMRs(anoxia, reoxygenation, regions = NULL, context = "CG", method = "bins", binSize = 100, test = "score", 
                      pValueThreshold = 0.01, minCytosinesCount = 4, minProportionDifference = 0.4, minGap = 200, minSize = 50, 
                      minReadsPerCytosine = 4, cores = 1)

write.table(B_AvsR, "DMR_B_AvsR.txt", sep = "\t", row.names = FALSE)


#NOISE
# normoxia vs anoxia 
N_NvsA <- computeDMRs(normoxia, anoxia, regions = NULL, context = "CG", method = "noise_filter", 
                      windowSize = 100, kernelFunction = "triangular", test = "score", pValueThreshold = 0.01, 
                      minCytosinesCount = 4, minProportionDifference = 0.4, minGap = 200, minSize = 50, minReadsPerCytosine = 4, 
                      cores = 1)
                      
write.table(N_NvsA, "DMR_N_NvsA.txt", sep = "\t", row.names = FALSE)

# normoxia vs reoxygenation
N_NvsR <- computeDMRs(normoxia, reoxygenation, regions = NULL, context = "CG", method = "noise_filter", 
                      windowSize = 100, kernelFunction = "triangular", test = "score", pValueThreshold = 0.01, 
                      minCytosinesCount = 4, minProportionDifference = 0.4, minGap = 200, minSize = 50, minReadsPerCytosine = 4, 
                      cores = 1)
                      
write.table(N_NvsR, "DMR_N_NvsR.txt", sep = "\t", row.names = FALSE)

# anoxia vs reoxygenation
N_AvsR <- computeDMRs(anoxia, reoxygenation, regions = NULL, context = "CG", method = "noise_filter", 
                      windowSize = 100, kernelFunction = "triangular", test = "score", pValueThreshold = 0.01, 
                      minCytosinesCount = 4, minProportionDifference = 0.4, minGap = 200, minSize = 50, minReadsPerCytosine = 4, 
                      cores = 1)
                      
write.table(N_AvsR, "DMR_N_AvsR.txt", sep = "\t", row.names = FALSE)

# you could try the settings from the paper for the noise method
