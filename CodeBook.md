## Code Book

### Introduction
This project uses data that represent data collected from accelerometers from the Samsung Galaxy S II smartphone. It is a Human Activity Recognition database built from the recordings of 30 subjects performing different activities while carrying a waist-mounted smartphone.

### Source
The data was downloaded from the [UCI Machine Learning Repository](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

### Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

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

### Transformations
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

Merging (using the `merge()` function) these two data sets gives us a data frame with 10,299 observations and 2 variables -- one variable representing the numeric code for the activity and one variable representing the correspinding activity label.  We save this data into the **activities** data frame.

Finally, we just add the activities data to our Xsub data frame as two additional columns.  Xsub now has 68 variables.

#### Labeling the data set
This part involves renaming the 67th and 68th variables of our Xsub data frame to *ActivityCode* and *ActivityName*, respectively.

#### Create a second, independent data set containing the mean of each variable for each activity and each subject.
Our Xsub data set does not yet have information on the subject, so we'll prepare this first.  We obtain the subject information from the *subject_test.txt* and *subject_train.txt* files and combine them with `rbind()`.  Note what we should be carefull to use the same order of row binding we did combining the X and the Y data to prevent inconsistency.

We now add the subjects data to our Xsub data as a new column named *Subject*.

Now that we have all the data we need, we use the `aggregate()` function to split the data into groups containing unique Subject and Activity values, and compute for the mean of each variable for each group.  We save this data to the **tidy** data frame.

### Citation Request:
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.