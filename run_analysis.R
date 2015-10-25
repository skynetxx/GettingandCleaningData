
## set workdingdirectory
setwd("C:\\Pub\\R Files\\R Grade\\Q3")

library(reshape2)

## download URL
downloadFile <- "data/getdata_dataset.zip"

## download filename 
downloadURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## set variables and download locations
train_XFile <- "./data/UCI HAR Dataset/train/X_train.txt"
train_Labels <- "./data/UCI HAR Dataset/train/y_train.txt"
train_SubjectFile <- ".data/UCI HAR Dataset/train/subject_train.txt"
test_XFile <- "./data/UCI HAR Dataset/test/X_test.txt"
test_Labels <- "./data/UCI HAR Dataset/test/y_test.txt"
test_SubjectFile <- ".data/UCI HAR Dataset/test/subject_test.txt"

## test for data foloder and zip file, if NOT found create
if(!file.exists("./data")) { dir.create("./data")}
if (!file.exists(downloadFile)) {
    download.file(downloadURL, downloadFile);
    unzip(downloadFile, overwrite = T, exdir = ".")
}

## Load activity labels 
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("./data/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## Extract mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

## Load the data sets
train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")[featuresWanted]
train_Activities <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
train_Subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, train_Activities, train)
test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")[featuresWanted]
test_Activities <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
test_Subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_Subjects, test_Activities, test)

## merge train and test data sets and add thier labels
mergeData <- rbind(train, test)
colnames(mergeData) <- c("subject", "activity", featuresWanted.names)

## turn activities & subjects into factors
mergeData$activity <- factor(mergeData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
mergeData$subject <- as.factor(mergeData$subject)
mergeData.melted <- melt(mergeData, id = c("subject", "activity"))
mergeData.mean <- dcast(mergeData.melted, subject + activity ~ variable, mean)

##The tidy data set
write.table(mergeData.mean, "tidy.txt", row.names=FALSE, quote=FALSE)