## before executing the following lines, we must set the woring directory to the floder that has the assignments files extracted
library(dplyr)

## create folder for the assignment files
wd_name = "c:/AssignmentFiles"
dir.create(wd_name, showWarnings = FALSE)
setwd(wd_name)

## download files
temp_file <- "getdata_projectfiles_UCI HAR Dataset.zip"
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp_file)
unzip(temp_file)
unlink(temp_file)
setwd(paste(wd_name, "UCI HAR Dataset", sep="/"))


## Read X and Y tables
x_test <- read.table("test/X_test.txt")
x_train <- read.table("train/X_train.txt")

y_test <- read.table("test/Y_test.txt")
y_train <- read.table("train/Y_train.txt")

## Read the features file to use them as variables names
ft <- read.table("features.txt")

## read the activities labels
activity_label <- read.table("activity_labels.txt")

## get list of variables names from features.txt file
lstNames <- ft[,2]

## rename test data set variables
colnames(x_test) <- lstNames

## rename train data set variables
colnames(x_train) <- lstNames

## rename activity column
colnames(y_test) <- c("Activity_ID")
colnames(y_train) <- c("Activity_ID")

## add new column for 
x_test <- cbind(x_test, y_test)
x_train <- cbind(x_train, y_train)


## bind the 2 data sets
new_ds <- rbind(x_test, x_train)

## extract only the variables of mean and std and store the result in new dataset called tidy_ds
tidy_ds <- new_ds[, colnames(new_ds[, grep(paste(c("mean", "std", "Activity"),collapse="|"), colnames(new_ds))])]

## add a column for the activity descriotion and update its value
tidy_ds <- cbind(tidy_ds, "Activity_Label"="")
tidy_ds$Activity_Label <- activity_label[tidy_ds$Activity_ID, 2]

## create dataset for average
tidy_ds_g <- aggregate(tidy_ds[, c(1:79)], by=list(tidy_ds$Activity_ID), FUN=mean, na.rm=TRUE)

## write data to file
write.table(tidy_ds_g, file = "tidy_ds_g.txt")
write.table(tidy_ds, file = "tidy_ds.txt")

