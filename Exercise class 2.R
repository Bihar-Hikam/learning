# --------------------------
# Assignment 2
# --------------------------
# In this assignment you will work with the results of differential gene expression (DGE) analysis. 
#The analysis produces two key measures for each gene:

# log2FoldChange (log2FC): 
# Indicates the magnitude and direction of change in gene expression. 
# Positive values suggest higher expression(upregulated gene) in the experimental condition compared to control. 
# Negative values suggest lower expression (downregulated gene). 
# The absolute value reflects the strength of the change.

# Adjusted p-value (padj): 
# Represents the statistical significance of the observed difference, corrected for multiple testing. 
# A smaller value indicates stronger evidence that the observed difference is not due to chance.

# Write a function classify_gene() 

classify_gene <- function(log2FC, padj) {
  if (log2FC > 1 & padj < 0.05) {
    return("Upregulated")
  } else if (log2FC < -1 & padj < 0.05) {
    return("Downregulated")
  } else {
    return ("Not_Significant")
  }
}


# For each file with in a loop:
#       - import data
#       - handle NA values
#       - calculate BMI using calculate_BMI function
#       - save results (both as CSV and inside R list)

# that takes:
#   - logFC (log2FoldChange)
#   - padj  (adjusted p-value)

# and returns:
#   - "Upregulated" if log2FC > 1 and padj < 0.05
#   - "Downregulated" if log2FC < -1 and padj < 0.05
#   - "Not_Significant" otherwise

# Then:
#   - Apply it in a for-loop to process both datasets (DEGs_data_1.csv, DEGs_data_2.csv)
#   - Replace missing padj values with 1
#   - Add a new column 'status'
#   - Save processed files into Results folder
#   - Print summary counts of significant, upregulated, and downregulated genes
#   - Use table() for summaries

# Define input and output folders
input_dir <- "Raw_Data"
output_dir <- "Result"

# List which files to process
files_to_process <- c("DEGs_Data_1.csv", "DEGs_Data_2.csv") 

# Prepare empty list to store results in R 
result_list <- list()

# Loop over each file
for (file_names in files_to_process) {
  cat("\nProcessing:", file_names, "\n")
  
  # Import dataset
  input_file_path <- file.path(input_dir, file_names)
  
  data <- read.csv(input_file_path, header = TRUE)
  cat("File imported. Checking for missing values...\n")
  
  # Replace missing padj value with 1
  if("padj" %in% names(data)){
    missing_count <- sum(is.na(data$height))
    
    cat("Missing values in 'padj':", missing_count, "\n")
    data$padj[is.na(data$padj)] <- 1
  }
  
  # Apply classification function
  data$status <- mapply(classify_gene, data$logFC, data$padj)
  cat("status has been processed successfully.\n")
  
  # save results in R
  result_list[[file_names]] <- data 
  
  # save results in Results folder
  output_file_path <- file.path(output_dir, paste0("Processed_", file_names))
  write.csv(data, output_file_path, row.names = FALSE)
  cat("Results saved to:", output_file_path, "\n")
  
  # Print summary counts
  cat("Summary of gene classification:\n")
  print(table(data$status))
}

# The loop repeats until all files are processed.
results_1 <- result_list[[1]] 
results_2 <- result_list[[2]]

# Save R Workspace File
save.image(file = "Bihar Hikam Ahmadi_Class_2_Assignment.RData")
