## Code Book

### Introduction
This project uses data that represent data collected from accelerometers from the Samsung Galaxy S II smartphone. It is a Human Activity Recognition database built from the recordings of 30 subjects performing different activities while carrying a waist-mounted smartphone.

### Source
The data was downloaded from the [UCI Machine Learning Repository](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

### Raw Data Collection

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.



### Data Files
These are the files used for this project

* activity_labels.txt - List of descriptive names for the 6 activities measured.

* features.txt - List of descriptive names for all the 561 variables of the data set.

* test/X_test.txt -  The test set of the measurements, comprised of 2,947 observations.

* test/y_test.txt - A single column of data containing the matching activity performed for each observation of the test set.  Range is from 1 to 6, each corresponding to a descriptive name in features.txt.

* test/subject_test.txt -  A single column of data representing the subject who performed the activity on the test set.

* train/X_train.txt - The training set of the measurements, comprised of 7,352 observations.

* train/y_train.txt - A single column of data containing the matching activity performed for each observation of the training set.  Range is from 1 to 6, each corresponding to a descriptive name in features.txt.

* train/subject_train.txt - A single column of data representing the subject who performed the activity on the training set. 

### Transformations (How to Create the Tidy Data)
The data was extracted from a zip file downloaded from the source mentioned above.  The relevant files were then loaded into separate data frames using the function `read.table()`.

#### Combining the training and test data
The next step involves combining the training and test data into one data frame named **X**.  X data frame contains 10,299 observations and 561 variables. This data came from the X_test.txt and Y_train.txt files.

We also combine the data representing the activity labels (from the files y_test.txt and y_train.txt) into the data frame **Y**.

These steps were performed using the R base function `rbind()`.

#### Extracting data with mean and standard deviation
We need to extract just the measurements on the mean and standard deviation for each measurement.  To do this we must first apply descriptive column names to our data set.  This is done by using setting the column names to the data we got from the file "features.txt".

Then, we filter the measurements using their column names -- we get only the columns matching the regular expression `(mean\\(|std)`.

The resulting data set, which we save to **Xsub**, now contains only 66 variables and still with 10,299 observations.  We also have a data set with descriptive column names.

#### Adding descriptive names to activities
By now, our data set does not have a column which describes which activity is being performed for a particular measurement.  This data is located in a separate data frame which we obtained from reading the *activity_labels.txt* file and the Y data frame we described earlier.

Merging (using the `join()` function) these two data sets gives us a data frame with 10,299 observations and 2 variables -- one variable representing the numeric code for the activity and one variable representing the correspinding activity label.  We save this data into the **activities** data frame.

Finally, we just add the activities data to our Xsub data frame as two additional columns.  Xsub now has 68 variables.

#### Labeling the data set
This part involves renaming the 67th and 68th variables of our Xsub data frame to *ActivityCode* and *ActivityName*, respectively.

#### Create a second, independent data set containing the mean of each variable for each activity and each subject.
Our Xsub data set does not yet have information on the subject, so we'll prepare this first.  We obtain the subject information from the *subject_test.txt* and *subject_train.txt* files and combine them with `rbind()`.  Note what we should be careful to use the same order of row binding we did when combining the X and the Y data to prevent inconsistency.

We now add the subjects data to our Xsub data as a new column named *Subject*.  Xsub now has 69 variables.

Now that we have all the data we need, we use the `aggregate()` function to split the data into groups containing unique Subject and Activity values, and compute for the mean of each variable for each group.  We save this data to the **tidy** data frame.

The tidy data frame now has 35 observations and 69 variables.

### Tidy Data Variables
* Subject - A numeric vector representing the subject who performed the activities measured.  Range is from 1 to 6.
* Activity Name - A char vector that represents a description of the activity measured.
* Activity Code - A numeric vector that identifies the activity code of the activity being measured.
* Other Variables
```R
tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag
```

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation


### Citation Request:
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.