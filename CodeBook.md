The features pulled from the tesst and train datasets were:

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The files contained a lot of summary statistics but only mean() and std() were extracted.

key variables in the R code:

allData:  a DF containing combined train and test files
meanSTD:  A DF with only the mean() and std() observations from allData
meanSTDlist:  Long form DF of meanSTD with added columns for easier interpretation of variable names
avgData:  A tidy DF with the average of each observation for each subject and activity
