#Inside the project directory, create the following subfolders using R code:
# raw_data, clean_data, scripts, results or Tasks, plots etc
dir.create("raw_data")
dir.create("clean_data")
dir.create("script")  
dir.create("results") 
dir.create("plots")

# load Data 
data <- read.csv(file.choose())

# View data in spreadsheet format
View(data)

# Check structure of the dataset
str(data)

# Convert 'gender' to factor
data$gender_fac <- as.factor(data$gender)
str(data)

# Convert 'diagnosis' to factor
data$diagnosis_fac <- as.factor(data$diagnosis)
str(data)

# Convert 'smoker' to factor
data$smoker_fac <- as.factor(data$smoker)
str(data)

# Convert factor to numeric using ifelse statement (Yes = 1, No = 0)
data$smoker_num <- ifelse(data$smoker_fac == "Yes", 1, 0)
class(data$smoker_num)
str(data)

# Save file  as CSV in clean_data folder
write.csv(data, file = "clean_data/patient_info_clean.csv")

# Save the entire R workspace
save.image(file = "BiharHikamAhmadi_Class_Ib_Assignment.RData")
