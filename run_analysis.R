## Download and unzip the data file.  Just uncomment the next 2 lines
## to download and unzip the file.
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "project.zip", method = "curl")
#unzip("project.zip")

#library(dplyr)

## Read the data
Xtest = read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest = read.table("./UCI HAR Dataset/test/y_test.txt")
Xtrain = read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain = read.table("./UCI HAR Dataset/train/y_train.txt")
features = read.table("./UCI HAR Dataset/features.txt")
XtestSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
XtrainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

## ----------------------------------------------------------------------
## 1. Merge the training and the test sets to create one data set
X <- rbind(Xtest, Xtrain)
Y <- rbind(Ytest, Ytrain)

## ----------------------------------------------------------------------
## 2. Extract only the measurements on the mean and std deviation
## First, let's add the descriptive column names so we can filter it.
## This also partially solves Problem #4.
colnames(X) <- features$V2
## Select only columns with 'std' and 'mean(' using regular expression
Xsub <- X[,grep('(mean\\(|std)', names(X), value = T)]

## ----------------------------------------------------------------------
## 3. Use descriptive activity names to name the activities in data set
activities <- merge(Y, activities)
Xsub <- cbind(Xsub, activities)

## ----------------------------------------------------------------------
## 4. Appropriately label the data set with descriptive variable names
## This is partially solved when we added the variable names from the 
## 'features' data frame in the Problem #2 solution.
colnames(Xsub)[67] <- "ActivityCode"
colnames(Xsub)[68] <- "ActivityName"

## ----------------------------------------------------------------------
## 5. From the data set in step 4, create a second, independent tidy data
##    set with the average of each variable for each activity and each
##    subject

## Combine the two subject data frames
Subject <- rbind(XtestSubject, XtrainSubject)

## Add subject column to our data set
Xsub <- cbind(Xsub, Subject)
colnames(Xsub)[69] <- "Subject"

## Compute for mean for each unique subject-activity combination
tidy <- aggregate(. ~ Subject + ActivityName, data = Xsub, mean)
arrange(tidy, Subject, ActivityName)

## Write the tidied data to file
write.table(tidy, "tidy.txt")