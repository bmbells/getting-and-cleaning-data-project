##download and unzip data##
if (file.exists("UCI HAR Dataset") == FALSE) {
        dataFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        dir.create("get data project")
        download.file(dataFile, "get data project/UCI-HAR-dataset.zip", method="curl")
        unzip("get data project/UCI-HAR-dataset.zip")
}


##organize and aggregate data, label all columns##
##steps 1 and 3##
setwd("UCI HAR Dataset")
features <- read.table("./features.txt")
activity_labels <- read.table("./activity_labels.txt")
subj_test <- read.table("./test/subject_test.txt")
subj_train <- read.table("./train/subject_train.txt")
subj <- rbind(subj_test, subj_train)
colnames(subj) <- "subject"

x_test <- read.table("./test/X_test.txt")
colnames(x_test) <- features[,2]
y_test <- read.table("./test/Y_test.txt")
colnames(y_test) <- "activity"
test_data <- cbind(y_test,x_test)

x_train <- read.table("./train/X_train.txt")
colnames(x_train) <- features[,2]
y_train <- read.table("./train/Y_train.txt")
colnames(y_train) <- "activity"
train_data <- cbind(y_train,x_train)

all_data <- rbind(test_data,train_data)

##grab just mean and std columns##
##Step 2##
gmean <- grep("mean()",colnames(all_data))
gstd <- grep("std()", colnames(all_data))
all_data2 <- all_data[,c(1,gmean,gstd)]

##relable activies##
##Step 4##
all_data3 <- merge(activity_labels,all_data2,  by.x= "V1", by.y= "activity")
all_data3 <- all_data3[,-1]
colnames(all_data3)[1] <- "activity"
final_data <- cbind(subj, all_data3) #add in subjects for next step

##create final tidy data set##
tidy_data <- aggregate(final_data[,3:dim(final_data)[2]], list(Subject = final_data$subject, Activity = final_data$activity), mean)
