setwd("~/Documents/Documents/Important Files/Hopkins/Data Science/Getting and Cleaning Data")

if(!file.exists("./projectdata")){dir.create("./projectdata")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./projectdata/projectDataset.zip")

# Unzip dataSet to /project data directory
unzip(zipfile="./projectdata/projectDataset.zip",exdir="./projectdata")

# Reading trainings tables:
x_train <- read.table("./projectdata/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./projectdata/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./projectdata/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./projectdata/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./projectdata/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./projectdata/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./projectdata/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./projectdata/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#Step One - Merges the training and the test sets to create one data set

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

colNames <- colnames(setAllInOne)

#Step Two - Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

#Step Three -  Uses descriptive activity names to name the activities in the data set
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
#Step Four - Appropriately labels the data set with descriptive variable names.
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#Step Five - From the data set in step four, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)