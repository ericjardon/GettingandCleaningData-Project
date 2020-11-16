# Codebook

Source of the data being used: [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

From the original README of the dataset:
"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years.
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 
we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments
have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two 
sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. "
(Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.)

The dataset's files being used for the current project, obtained from the UCI website include the following:
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

###Notes: 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

## Summary decisions
As per project instructions it was required that we merge both the training data and the test data into a single data frame, 
and then to proceed by taking the average value of only the 66 features that correspond to mean() and std() variables from the
original dataset. 
The resulting, summarized table is a 40x69 table, grouped by *<Subject Id, Activity Label>* pairs (40 total).
It was decided to keep both the activity name and number id in the dataframe, with column names respectively as "activity" and "label". 
Following instructor's criteria, descriptive names are considered all lowercase and without special characters.
