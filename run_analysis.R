
#Clear variables
rm(list = ls())

#Reference libraries
library(reshape2)
library(dplyr)
 
#Download and unzip files
urll<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile<-paste0(getwd(),"/","dataweek4.zip")
download.file(urll,destfile)
unzip("dataweek4.zip",exdir = getwd(), list = FALSE, overwrite = TRUE)
path<-"./UCI HAR Dataset/"
 
#Read features and activities
activity_labels<-read.table(paste0(path, "activity_labels.txt"))
features<-read.table(paste0(path, "features.txt"))
 
#Read the test files
subject_test<-read.table(paste0(path, "test/subject_test.txt"))
x_test<-read.table(file=paste0(path, "test/X_test.txt"))
y_test<-read.table(file=paste0(path, "test/y_test.txt"))

#Read the train files
subject_train<-read.table(paste0(path, "train/subject_train.txt"))
x_train<-read.table(paste0(path, "train/X_train.txt"))
y_train<-read.table(paste0(path, "train/y_train.txt"))

#Rename columns
colnames(x_test)<-features[,2]
colnames(x_train)<-features[,2]
colnames(y_test)<-"Activity"
colnames(y_train)<-"Activity"
colnames(subject_test)<-"Subject"
colnames(subject_train)<-"Subject"
 
#Question 1:  Combine train and test datasets
testData<-cbind(subject_test, y_test, x_test)
trainData<-cbind(subject_train, y_train, x_train)
allData<-rbind(testData, trainData)
 
#Question 2:  Extract only the means and standard deviations of each measurement
s<-grep("mean|std", colnames(allData), ignore.case=TRUE)
meanSTD<-allData[,c(1,2,s)]
#Remove meanFreq and angle measurements
s<-grep("meanfreq|angle", colnames(meanSTD), ignore.case=TRUE)
meanSTD<-meanSTD[,-s]
 
#Question 3:  Rename the activity labels (column 2)
meanSTD[,2]<-activity_labels[meanSTD[,2], 2]

#Question 4:  Add descriptive variable names
#I am going to melt the data to make it easier to read (tidy-ish)
meanSTDlist<-melt(meanSTD, id.vars = c("Activity", "Subject")) 

#break the variable column into descriptive labels
holder<-as.data.frame(matrix(, nrow(meanSTDlist), 6))
s<-grep("body", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 1]<-"Body"
s<-grep("gravity", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 1]<-"Gravity"
s<-grep("gyro", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 2]<-"Gyroscope"
s<-grep("acc", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 2]<-"Accelerometer"
s<-grep("jerk", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 3]<-"Jerk"
s<-grep("mag", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 3]<-"Magnitude"
s<-grep("-x", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 4]<-"X-axis"
s<-grep("-y", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 4]<-"Y-axis"
s<-grep("-z", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 4]<-"Z-axis"
s<-grep("^f", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 5]<-"Fourier"
s<-grep("^t", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 5]<-"Time"
s<-grep("mean", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 6]<-"Mean"
s<-grep("std", meanSTDlist[,"variable"], ignore.case=TRUE)
holder[s, 6]<-"Std Dev"
colnames(holder)<-c("Location", "Instrument", "Jerk or Mag", "Axis", "Units", "Measurement")
meanSTDlist<-cbind(meanSTDlist, holder)
meanSTDlist<-meanSTDlist[, c(1, 2, 3, 5, 6 ,7 ,8, 9, 10, 4)]

#Question 5:  Tidy data set with the average of each variable
#Tidy Data:
#1. Each variable forms a column.
#2. Each observation forms a row.
#3. Each type of observational unit forms a table. 


avgData<-meanSTDlist %>%
	group_by(Activity, Subject, variable, Measurement) %>%
	summarise(Average = mean(value))





