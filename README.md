## Introduction
This repository contains my solution to the Course Project in **Getting and Cleaning Data** course in Coursera.

## Files
This repository contains the following files:

* run_analysis.R
* CodeBook.md
* README.md

### run_analysis.R
The first section of the script deals with downloading, unzipping the source file and then loading each of the extracted data files into data frames.

~~~R
## Download and unzip the data file.  Just uncomment the next 2 lines
## to download and unzip the file.
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "project.zip", method = "curl")
#unzip("project.zip")

## Read the data
Xtest = read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest = read.table("./UCI HAR Dataset/test/y_test.txt")
Xtrain = read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain = read.table("./UCI HAR Dataset/train/y_train.txt")
features = read.table("./UCI HAR Dataset/features.txt")
XtestSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
XtrainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
~~~

The second part of the script provides a solution to the first part of the project.  It simply combines into one data set the separate training and test sets.  This is done on both the data set and the label data.

~~~R
## ----------------------------------------------------------------------
## 1. Merge the training and the test sets to create one data set
X <- rbind(Xtest, Xtrain)
Y <- rbind(Ytest, Ytrain)
~~~

This section selects only the columns conaining mean ("mean()") and standard deviation ("std").  This results in a data frame with *66 columns*.

~~~R
## ----------------------------------------------------------------------
## 2. Extract only the measurements on the mean and std deviation
## First, let's add the descriptive column names so we can filter it.
## This also partially solves Problem #4.
colnames(X) <- features$V2
## Select only columns with 'std' and 'mean(' using regular expression
Xsub <- X[,grep('(mean\\(|std)', names(X), value = T)]
~~~

The next section gives a solution for problem #3 of the project.  We load the *activity_labels.txt* file then we join this data with the labels data (Y) we got earlier.  We then add this information to our data set, adding a new column with descriptive activity labels.

In merging Y with the activity labels, it's important to use plyr's join() function instead of merge().  This will preserve the order of the Y data.

~~~R
## ----------------------------------------------------------------------
## 3. Use descriptive activity names to name the activities in data set.  
activities <- join(Y, activities)
Xsub <- cbind(Xsub, activities)
~~~

The following section adds descriptive column names, using the *features* data frame as source of names for columns 1-66.  We also manually add descriptive names for the 67th and 68th columns we added earlier.  This solves problem #4.

~~~R
## ----------------------------------------------------------------------
## 4. Appropriately label the data set with descriptive variable names
## This is partially solved when we added the variable names from the 
## 'features' data frame in the Problem #2 solution.
colnames(Xsub)[67] <- "ActivityCode"
colnames(Xsub)[68] <- "ActivityName"
~~~

To solve problem #5, we first have to add a Subject column to our data set.  The Subject column is first combined from the train and test data frames, and then added to our data set.

Next, create a new data set *tidy* which contains the computed mean for each measurement for a given subject and activity.

Finally, we write our tidied data set to file.

~~~R
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
tidy <- arrange(tidy, Subject, ActivityName)

## Write the tidied data to file
write.table(tidy, "tidy.txt", row.names = FALSE)
~~~

### CodeBook.md
This file describes the variables, the data and any transformations performed to clean up this data.

### README.md
This file.