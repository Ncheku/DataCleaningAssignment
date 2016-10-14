#set working directory if needed
setwd("c:/users/mija/desktop/R/cleaning/assignment/UCI HAR Dataset")

#load packages
library("data.table")
library("reshape2")
library("dplyr")

# Load data 
# meta data
activity_labels <- read.table("./activity_labels.txt")
features <- read.table("./features.txt") [,2]

# test
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

#train
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

# Combine
subject <- rbind(subject_test, subject_train)
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)

#labels
names(activity_labels) <- c("activity_id", "activity_name")
names(subject) <- "subject"
names(y) <- "activity_id"
names(x) <- features


##combine
combined_activity <- cbind(subject, y)
combined_data <- cbind(combined_activity, x)

##select only means and std
meanstd <- grep("mean|std)",features,ignore_case=TRUE, value=TRUE)
extract_features <- union(c("subject", "activity_id"), meanstd)
combined_meansstd <- combined_data [,extract_features]

## activity names
combined_meansstd_activity <- merge(activity_labels, combined_meansstd, by='activity_id', all.x=TRUE) 
combined_meansstd_activity <- combined_meansstd_activity[, c(3, 2, 4:89)]

## better variable names
names(combined_meansstd_activity)<-gsub("^t", "time_", names(combined_meansstd_activity))
names(combined_meansstd_activity)<-gsub("^f", "frequency_", names(combined_meansstd_activity))
names(combined_meansstd_activity)<-gsub("std()", "SD", names(combined_meansstd_activity))
names(combined_meansstd_activity)<-gsub("mean()", "MEAN", names(combined_meansstd_activity))
names(combined_meansstd_activity)<-gsub("BodyBody", "Body", names(combined_meansstd_activity))

## write out table
write.table(combined_meansstd_activity, file = "./final_set.txt", row.name=FALSE )
