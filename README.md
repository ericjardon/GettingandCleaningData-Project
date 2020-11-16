# GettingandCleaningData-Project
Hello! This is my R code repository for the final peer-reviewed project of Getting &amp; Cleaning Data course on Coursera.
Thank you in advance for reviewing my work.

### Contains:
- An R script that downloads, cleans and summarises wearable computing data from the UCI Machine Learning Repository
- A README.md file that explains the project and how the script works
- A Codebook.md file that describes the variables 

### run_analysis.R
This script does the following:
1) Merges the training and the test datasets into a single, clean data set.
2) Extracts from the original data only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names (criteria: all lowercase, no special characters).
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Step-by-step explanation of the script
1. First download the data from the source url provided by the course instructors.
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. We make sure that all the necessary files are present in the working directory. Otherwise we stop execution.
3. We read the data from the txt files using read.table and use proper column names.
4. We subset the data to the 66 variables we need: all those of type mean() and std()
5. We combine by columns the training values, labels and subjects into a single table. We do the same for the test data. We then merge both.
6. We write the resulting full data table into a txt file in the working directory.
7. We then summarize the full data by grouping into unique combinations of subject-activity, and take the average value of each of the 66 variables.
8. Finally we write out the summarized, tidy data table into a text file in the working directory.

_Make sure to also check out the codebook in case you want to know more information about the data being used._ 
