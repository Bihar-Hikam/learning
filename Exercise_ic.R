# Practice Exercises 

# ----------------------------------------------------------------------------------------------------------------

# 1. Check Cholesterol level
# If statement to check cholesterol level is greater than 240, 
# if true, it will prints “High Cholesterol”

cholesterol <- 230

if (cholesterol > 240) {
  print("High Cholesterol")
}

# ----------------------------------------------------------------------------------------------------------------

# 2. Blood Pressure Status (using if...else)
# if else statement to check if blood pressure is normal.
# If it’s less than 120, print: “Blood Pressure is normal”
# If false then print: “Blood Pressure is high”

Systolic_bp <- 130

if (Systolic_bp < 120) {
  print("Blood Pressure is normal")
} else {
  print("Blood Pressure is high")
}


# ----------------------------------------------------------------------------------------------------------------

# 3. Automating Data Type Conversion with for loop

# Use patient_info.csv data and its metadata.
patient_info <- read.csv(file.choose())
patient_info

metadata <- read.csv(file.choose())
metadata

# Create a copy of the dataset to work on.
patient_data <- patient_info
metadata_data <- metadata   

# Identify all columns that should be converted to factor type.
# Store their names in a variable (factor_cols).
str(patient_data)
factor_cols_patient <- c("gender", "diagnosis", "smoker")

str(metadata_data)
factor_cols_metadata <- c("height", "gender")

# Use a for loop to convert all the columns in factor_cols to factor type.
# Pass factor_cols to the loop as a vector.

for (col in factor_cols_patient) {
  patient_data[[col]] <- as.factor(patient_data[[col]])
}

for (col in factor_cols_metadata) {
  metadata_data[[col]] <- as.factor(metadata_data[[col]])
}
# ----------------------------------------------------------------------------------------------------------------

# 4. Converting Factors to Numeric Codes

# Choose one or more factor columns (e.g., smoking_status).
# Convert "Yes" to 1 and "No" to 0 using a for loop.
# Patient_data
binary_cols_smoker <- c("smoker")
binary_cols_diag <- c("diagnosis")

# Metadata_data
binary_cols_gender <- c("gender")
binary_cols_height <- c("height")

# use ifelse() condition inside the loop to replace Yes with 1 and No with 0
# Patient_data
for (col in binary_cols_smoker) {
  patient_data[[col]] <- ifelse(patient_data[[col]] == "Yes", 1, 0)
}

for (col in binary_cols_diag) {
  patient_data[[col]] <- ifelse(patient_data[[col]] == "Cancer", 1, 0)
}

# Metadata_data
for (col in binary_cols_gender) {
  metadata_data[[col]] <- ifelse(metadata_data[[col]] == "Male", 1, 0)
}

# ----------------------------------------------------------------------------------------------------------------

#  Verification:
#    Compare the original and modified datasets to confirm changes.
str(patient_info)
str(patient_data)

str(metadata)
str(metadata_data)

# ----------------------------------------------------------------------------------------------------------------
