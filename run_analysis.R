#set working directory if needed

#load packages
library("data.table")
library("reshape2")

# Load data 
activity_labels <- read.table("./activity_labels.txt")[,2]
features <- read.table("./features.txt")[,2]

x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")


#lables
activity_name <- c("Activity_ID", "Activity_Label")
labels = c("subject", "Activity_ID", "Activity_Label")
names(subject_train) = "subject"
names(subject_test) = "subject"

sub_features <- grepl("mean|std", features)
names(x_test) = features
x_test = x_test[,sub_features]

# Load activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = activity_name

# Bind data
test_data <- cbind(as.data.table(subject_test), y_test, x_test)

############################

##train data
names(x_train) = features
x_train = x_train[,sub_features]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = activity_name

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, x_train)


####################################
# Merge test and train data
data = rbind(test_data, train_data)

data_labels = setdiff(colnames(data), id_labels)
reshape=melt(data, id = labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
final_set= dcast(reshape, subject + Activity_Label ~ variable, mean)
write.table(final_set, file = "./final_set.txt", row.name=FALSE )

