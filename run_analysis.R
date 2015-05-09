### run_analysis.R
### 
### 1 Merges the training and the test sets to create one data set.
### 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
### 3 Uses descriptive activity names to name the activities in the data set
### 4 Appropriately labels the data set with descriptive variable names. 
### 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
################################################################################################
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")
################################################################################################
# features
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# activiity_labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
################################################################################################
### train ###
  # train_id #
train_id <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(train_id) = "ID"

  # train_labels #
train_labels <- read.table("./UCI HAR Dataset/train/Y_train.txt") 
train_labels[,2] = activity_labels[train_labels[,1]]
names(train_labels) = c("activity", "labels")

  # train_data #
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
names(train_data) = features

  # train: cbind #
train <- cbind(train_id, train_labels, train_data)
################################################################################################
### test ###
  # test_id #
test_id <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(test_id) = "ID"

  # test_labels #
test_labels <- read.table("./UCI HAR Dataset/test/Y_test.txt") 
test_labels[,2] = activity_labels[test_labels[,1]]
names(test_labels) = c("activity", "labels")

  # test_data #
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
names(test_data) = features

  # test: cbind #
test <- cbind(test_id, test_labels, test_data)
################################################################################################
### rbind: train & test ###
want_1 <- rbind(train, test)
select_features <- grepl("mean|std", features) 
select_features <- c(TRUE, TRUE, TRUE, select_features)
want_2 <- want_1[,select_features]
################################################################################################
# item 5 independent tidy data set with the average of each variable for each activity and each subject.
id_labels   = c("ID", "activity", "labels")
data_labels = setdiff(colnames(want_2), id_labels)
melt_data   = melt(want_2, id = id_labels, measure.vars = data_labels)

tidy_data   = dcast(melt_data, ID + labels ~ variable, mean)
################################################################################################
write.table(tidy_data, file = "./tidy_data.txt",  row.name=FALSE)
################################################################################################
