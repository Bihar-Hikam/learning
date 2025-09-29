# Bioconductor provides R packages for analyzing omics data (genomics, transcriptomics, proteomics etc).

if (!requireNamespace("BiocManager", quietly = TRUE)) 
  install.packages("BiocManager")

# Install Bioconductor packages
BiocManager::install(c("GEOquery","affy","arrayQualityMetrics"))

# Install CRAN packages for data manipulation
install.packages("dplyr")

# Load Required Libraries
library(GEOquery)             # Download GEO datasets (series matrix, raw CEL files)
library(affy)                 # Pre-processing of Affymetrix microarray data (RMA normalization)
library(arrayQualityMetrics)  # QC reports for microarray data
library(dplyr)                # Data manipulation


# -------------------------------------
#### Load Series Matrix Files ####
# -------------------------------------
library(GEOquery)

# Load series matrix 
gse_data <- getGEO(filename = "Breast Cancer/GSE43837_series_matrix.txt.gz")

# Extract phenotype (sample metadata) & feature (probe annotation) data
pheno_data <- pData(gse_data)      # data sampel
feature_data <- fData(gse_data)    # data fitur/probe

# Check missing values in sample annotation
sum(is.na(pheno_data$source_name_ch1))

# --------------------------------------
#### Load Raw Data (CEL files) ####
# --------------------------------------

# Untar CEL files if compressed as .tar
untar("Breast Cancer/GSE43837_RAW.tar", exdir = "Breast Cancer/CEL_Files")

# Read CEL files into R as an AffyBatch object
raw_data <- ReadAffy(celfile.path = "Breast Cancer/CEL_Files")

raw_data   # Displays basic information about the dataset

# ---------------------------------------------------
#### Quality Control (QC) Before Pre-processing ####
# ---------------------------------------------------

# QC identifies outlier arrays, hybridization problems, or technical biases.
# arrayQualityMetrics: # This package generates automated QC reports for microarray data.
# It applies multiple complementary methods to detect technical issues:
#   - Boxplots and density plots: check distribution of intensities 
#   - MA-plots: visualize systematic biases between arrays 
#   - Heatmaps and distance matrices: identify clustering/outliers
#   - PCA: detect unusual variation/detecting outliers or batch effects
#
# The output is an interactive HTML report (index.html file) summarizing QC results.

arrayQualityMetrics(expressionset = raw_data,
                    outdir = "Results/QC_Raw_Data",
                    force = TRUE,
                    do.logtransform = TRUE)

# -------------------------------------------------------
#### RMA (Robust Multi-array Average) Normalization ####
# -------------------------------------------------------

# RMA is a popular method for normalizing Affymetrix microarray data by:
# 1. Background correcting, 
# 2. normalizing probe intensities using quantile normalization and 
# 3. summarizing them into gene-level expression values using a robust median polish algorithm.

# This method reduces experimental variation across multiple arrays, 
# producing more symmetrical and reliable normalized expression data 
# compared to other approaches

normalized_data <- rma(raw_data)

# QC after data normalization 
arrayQualityMetrics(expressionset = normalized_data,
                    outdir = "Results/QC_Normalized_Data",
                    force = TRUE)

# Extract normalized expression values into a data frame
processed_data <- as.data.frame(exprs(normalized_data))

dim(processed_data)   # Dimensions: number of probes × number of samples

# ---------------------------------------------------------------------------
#### Filter Low-Variance Transcripts (“soft” intensity based filtering) ####
# ---------------------------------------------------------------------------

# Filtering removes probes with low or uninformative expression signals.
# Reason: Reduces noise and improves statistical power in differential expression & Machine Learning.

# Calculate median intensity per probe across samples
row_median <- rowMedians(as.matrix(processed_data))

# Visualize distribution of probe median intensities
hist(row_median,
     breaks = 100,
     freq = FALSE,
     main = "Median Intensity Distribution")

# Set a threshold to remove low variance probes (dataset-specific, adjust accordingly)
threshold <- 3.5 
abline(v = threshold, col = "black", lwd = 2) 

# Select probes above threshold
indx <- row_median > threshold 
filtered_data <- processed_data[indx, ] 
dim(filtered_data)

# Rename filtered expression data with sample metadata
colnames(filtered_data) <- rownames(pheno_data)

# Overwrite processed data with filtered dataset
processed_data <- filtered_data 

# -----------------------------------
#### Phenotype Data Preparation ####
# -----------------------------------

# Phenotype data contains sample-level metadata such as condition, 
# tissue type, or disease status.
# Required to define experimental groups for statistical analysis.

class(pheno_data$source_name_ch1) 

# Define experimental groups (normal vs cancer)
groups <- factor(pheno_data$source_name_ch1,
                 levels = c("brain metastasis", "primary breast tumor"),
                 label = c("disease", "control"))

class(groups)
levels(groups)