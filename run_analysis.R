# Run Analysis -- Getting & Cleaning Data
# Author -- Eric Jardon Chao
library(data.table)
library(dplyr)

## DOWNLOADING THE DATA FROM R 
# Use of a dedicated directory for flexibility across different paths
workingDir <- "./workDir"
if (!dir.exists("./workDir")) {dir.create("./workDir")}
setwd("./workDir")

# The url points to a zip file so we need to unzip it
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, "UCI_Datasets.zip",  quiet = TRUE, mode = "wb")
# extra params to avoid corrupted files in Windows OS
zipFile <- "UCI_Datasets.zip"
if (file.exists(zipFile)){unzip(zipFile)}

# File paths for all the files we need
features <- "UCI HAR DataSet/features.txt"
activity_labels <- "UCI HAR DataSet/activity_labels.txt"
variables_test <- "UCI HAR DataSet/test/X_test.txt"
labels_test <- "UCI HAR DataSet/test/y_test.txt"
subject_test <- "UCI HAR DataSet/test/subject_test.txt"
variables_train <- "UCI HAR DataSet/train/X_train.txt"
labels_train <- "UCI HAR DataSet/train/y_train.txt"
subject_train <- "UCI HAR DataSet/train/subject_train.txt"

## Optional - Check that all files are present in working dir
myFiles <- c(features, activity_labels, variables_test, labels_test,
             subject_test, variables_train, labels_train, subject_train)

for (file in myFiles) {
  if (!file.exists(file)) {
    stop(paste("Error: ", file, " not found. Stopping execution.", sep=""))
  } else print(paste("File", file, "exists."))
}


# READING THE DATA
# Reading the features file
allfeatures <- read.table(features, col.names=c("row","variablename"))
# Fix the duplicated string 'BodyBody' error in variable names
allfeatures <- mutate(allfeatures, variablename = gsub("BodyBody", "Body",
                                                       variablename))
# Make a subset of only the variables  we need: mean() and std()
regEx <- "mean\\(\\)|std\\(\\)"
myfeatures <- filter(allfeatures, grepl(regEx, variablename))

# Remove parenthesis and other non alphanumeric symbols from both tables
myfeatures <- mutate(myfeatures, variablename = tolower(variablename),
                                 variablename = gsub("\\(", "", variablename),
                                 variablename = gsub("\\)", "", variablename),
                                 variablename = gsub("-", "", variablename))
allfeatures <- mutate(allfeatures, variablename = tolower(variablename),
                     variablename = gsub("\\(", "", variablename),
                     variablename = gsub("\\)", "", variablename),
                     variablename = gsub("-", "", variablename))


## CREATING A SINGLE TEST DATA TABLE
# 1. Reading the activity labels file
activitylabels <- read.table(activity_labels, col.names=c("label", "activity"))

# 2. Reading test data values subset by the clean names of myfeatures
testvars <- read.table(variables_test, col.names=c(allfeatures$variablename)) 
# subsetting the columns to only those features we need
testvars <- testvars[, myfeatures$variablename]

# 3. Reading activity labels of test data
testlabels <- read.table(labels_test, col.names=c("label"))

# 4. Reading test data subjects
testsubjects <- read.table(subject_test, col.names=c("subjectid"))

# 5. Add activity name to the testlabels by merging it with activitylabels
testlabelswname <- merge(testlabels, activitylabels, by="label")

# 6. All 2947 rows are in order in the three test tables,
# So we can combine by columns the three of them
testdata <- cbind(testsubjects,testlabelswname, testvars)


## CREATING A SINGLE TRAIN DATA TABLE
# 1. Read the training values and naming the columns appropriately
trainvars <- read.table(variables_train, col.names=c(allfeatures$variablename))
# subset the columns to only those features we need
trainvars <- trainvars[, myfeatures$variablename]

# 2. Reading activity labels of train data
trainlabels <- read.table(labels_train, col.names = c("label"))

# 3. Reading subjects of train data
trainsubjects <- read.table(subject_train, col.names=c("subjectid"))

# 4. Adding activity name to the train labels table
trainlabelswname <- merge(trainlabels, activitylabels, by="label")

# 5. All 7352 rows are in order in the 3 train tables,
# so we can combine columns of the 3 train tables
traindata <- cbind(trainsubjects, trainlabelswname, trainvars)


## WRITING OUT A TXT FILE OF BOTH DATASETS
data <- rbind(testdata, traindata)
write.table(data, "Mean_and_Std_Per_SubjectActivity.txt")
# we have 10299 observations per row so the table is complete


## CREATING A SECOND SUMMARISED DATASET
# We only want to include the average values of each of the 66 variable 
# grouped by subject and activity

# Make the subject and activity values to be factor variables
data$activity <- as.factor(data$activity)
data$subjectid <- as.factor(data$subjectid)

# Group by subject and activity (40 groups) and apply mean to columns 4 through 69
avgdata <- data
avgdata <- avgdata %>%
  group_by(subjectid, activity) %>%
  summarise(across(cols=4:69, .fns=mean), .groups="keep")

## AT LAST, WRITE OUT THE SUMMARISED TABLE
write.table(avgdata, "Average_Variables_Per_SubjectActivity.txt", row.names = FALSE)

