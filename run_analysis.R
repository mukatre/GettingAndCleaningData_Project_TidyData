## Create one R script called run_analysis.R that does the following. 
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

if(!require("data.table")) {
	install.packages("data.table")
}
library(data.table)
if(!require("reshape2")) {
	install.packages("reshape2")
}
library(reshape2)

##read column 2 of activity labels and features
activitylabels <- read.table("activity_labels.txt")[,2]
features <- read.table("features.txt")[,2]

## read test data
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/Y_test.txt")
Sub_test <- read.table("./test/subject_test.txt")

## read training data
X_training <- read.table("./train/X_train.txt")
Y_training <- read.table("./train/Y_train.txt")
Sub_training <- read.table("./train/subject_train.txt")

mean_sd <- grepl("mean|std", features)

## TEST DATA:  Extract only the measurements on the mean and standard deviation for each measurement.
	## name the columns
	names(X_test) <- features
	## extract measurements on the mean and std dev
	X_test_mean_sd <- X_test[,mean_sd]
	## add activity labels
	Y_test[,2] <- activitylabels[Y_test[,1]]
	## name the columns
	names(Y_test) <- c("ID","Activity_Label")
	names(Sub_test) <- "Subject"
	## extract measurements
	testData <- cbind(as.data.table(Sub_test), Y_test, X_test_mean_sd)

## TRAINING DATA: Extract only the measurements on the mean and standard deviation for each measurement.
	## name the columns
	names(X_training) <- features
	## extract measurements on the mean and std dev
	X_training_mean_sd <- X_training[,mean_sd]
	## add activity labels
	Y_training[,2] = activitylabels[Y_training[,1]]
	## name the columns
	names(Y_training) <- c("ID", "Activity_Label")
	names(Sub_training) = "Subject"
	## extract measurements
	trainingData <- cbind(as.data.table(Sub_training), Y_training, X_training_mean_sd)

## Merge training and test data
	allData <- rbind(testData, trainingData)

labels <- c("Subject", "ID", "Activity_Label")
data_labels <- setdiff(colnames(allData), labels)
meltData <- melt(allData, id = labels, measure.vars = data_labels)

tidyData <- dcast(meltData, Subject+Activity_Label ~ variable, mean)

write.table(tidyData, file = "tidyData.txt")
	
