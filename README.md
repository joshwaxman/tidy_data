---
title: "README"
author: "Joshua Waxman"
date: "Sunday, November 23, 2014"
output: html_document
---

##Summary
This code was written for the course project for the "Getting and Cleaning Data" course on Coursera. It reads in several tab-delimited files, combines them in various ways, and selects certain columns of interest. It then summarizes and tidies the combined data.

##Input
The input files constitute the "Human Activity Recognition Using Smartphones Dataset, Version 1.0", and were obtained from this weblink:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The zip contains the following folder structure, with these relevant files:

* UCI HAR Dataset/features.txt -- a tab delimited file mapping column numbers to column labels for the dataset. This describes 561 columns.
* UCI HAR Dataset/activity_labels.txt -- a tab delimited file mapping activity numbers to activity descriptors for the dataset. This describes 6 activities.
* UCI HAR Dataset/test/subject_test.txt -- this contains a single column, with the same number of rows as the test data set, specifying to which subject (person) the row in the test data set pertains.
* UCI HAR Dataset/train/subject_train.txt -- the same as described above, but for the **training** data set.
* UCI HAR Dataset/test/y_test.txt -- this contains a single column, with the same number of rows as the test data set, specifying by number (1 through 6) to which activity the row in the test data set pertains.
* UCI HAR Dataset/train/y_train.txt -- the same as described above, but for the **training** data set.
* UCI HAR Dataset/test/X_test.txt -- this is the main body of data, for the test training set. It contains 561 columns of data, of measurements taken by a Samsung smartphone worn by the subject as he or she performed each of the six activities.
* UCI HAR Dataset/train/x_train.txt -- the same as described above, but for the **training** data set.
* UCI HAR Dataset/README.txt -- describes the experiment and function of these files in a lot more detail.

##Output
A singe table summarizing the above data in a tidy fashion giving, for each combination of subject and activity, the average of the mean and standard deviation of each of the measurements, broken down by dimension. This is described in more detail in the Codebook attached to this project.

##Processing
This describes how we transform the Input into the Output.

###process_data
The program starts in the ```{r}process_data()``` function. This performs the following steps:

1. Obtain the **test** data set, using the ```{r}obtain_data()``` function. This data set has all column labels, activity labels, and subject ids already included.
2. Obtain the **training** data set, using the ```{r}obtain_data()``` function.
3. Combine the test and training data frames together using the built-in ```{r}rbind()``` function.
4. Summarize the data using the ```{r}get_averages()``` function. While the original data might have had, for a given subject and activity, many rows of measurements, this will instead give,  for a given subject and activity, the mean of those rows.
5. Tidy the data using the ```{r}tidy_data()``` function.

###obtain_data
This function takes a string argument, with values of "test" or "train", and will obtain either the test or training data. (It uses this argument to farbricate the correct path to the data.)

It performs the following steps.
1. Read in the necessary input files for column labels, activity labels, the subject column, and the main body of data. We assign the main body of data to a variable called ```{r}the_data```.
2. Massage the column labels, by removing the () and (dbl) where they often occur at the end of the column label.
3. Assign the column labels to ```{r}the_data```.
4. Find all columns which have "mean" or "std" at a word boundary (by using regular expressions). These are the only columns we are interested in, so we select only those columns and omit everything else, assigninh the result to ```{r}the_data```.
5. The single column data frame of activities pertaining to the rows in ```{r}the_data``` are numbers, while we want activity labels. We use ```{r}inner_join``` and ```{r}select``` from the ```{r}dplyr``` package to replace the numbers for the activity labels.
6. We ```{r}cbind``` the subject and activity labels onto ```{r}the_data```.

###get_averages
This function summarizes the data. It uses functions from the ```{r}dplyr``` package.

It first groups the data by subject and activity.

Then, it summarizes, by taking the mean for all columns in each group.

###tidy_data
This function tidies the data, using functions from the ```{r}tidyr``` package.

Ignoring the first two columns (subject and activity), it ```{r}gather``` the remaining columns, into a key column called measure_computation_dimension and a value column called value. The measure_computation_dimension contains the name of the measure used, such as tBodyAcc-mean-X or tBodyAcc-mean-Y, and the value column contains the value that used to be in the field for that row and the column by the key name.

Then, it ```{r}separate```s the measure_computation_dimension column into three columns, namely measure, computation, and dimension. Thus, for instance, a value of tBodyAcc-mean-Y would become "tBodyAcc" for the measure, "mean" for the computation, and "Y" for the dimension.

Some measure_computation_dimensions only have a measure and computation but no dimension. For example, fBodyBodyGyroJerkMag-std has a measure of "fBodyBodyGyroJerkMag" and a computation of "std" but no dimension of "X", "Y", or "Z". In such a case, NA is assigned.

###Why the data is tidy
The following is a definition of tidy data, pulled from the swirl interactive program for this course:
1. Each variable forms a column
2. Each observation forms a row
3. Each type of observational unit forms a table

The wide data coming in might perhaps be considered "messy". There are **many, many** columns with names such as tBodyAcc-mean-X, tBodyAcc-mean-Y, tBodyAcc-mean-Z, tBodyAcc-std-X, tBodyAcc-std-Y, tBodyAcc-std-Z, tGravityAcc-mean-X, tGravityAcc-mean-Y, tGravityAcc-mean-Z, tGravityAcc-std-X, tGravityAcc-std-Y, tGravityAcc-std-Z, and so on.

We can compare this with the example given there of messy data:

| grade | male  | female |
|-------|-------|--------|
|   A   |   1   |   5    |
|   B   |   5   |   0    |
|   C   |   5   |   2    |
|   D   |   5   |   5    |
|   E   |   7   |   4    |

The complaint was that rather than having separate columns for male and female is that the data set actually had three variables, grade, gender, and count.

So too here, our table actually had four five variables:
1. subject
2. activity
3. measure
4. computation
5. dimension
6. value

Our tidying ensured that each variable formed a column. The resulting tables looks like this (looking just at the head):


|  subject  |         activity |  measure | computation | dimension |       value  |
|---        |---               |--        |---          |---        |---           |
|       1   |          LAYING  | tBodyAcc |        mean |       X   | 0.2215982    |
|       1   |         SITTING  | tBodyAcc |        mean |       X   | 0.2612376    |
|       1   |      STANDING    | tBodyAcc |        mean |       X   | 0.2789176    |
|       1   |        WALKING   | tBodyAcc |        mean |       X   | 0.2773308    |
|       1   |WALKING_DOWNSTAIRS| tBodyAcc |        mean |       X   | 0.2891883    |
|       1   | WALKING_UPSTAIRS | tBodyAcc |        mean |       X   | 0.2554617    |

And, measure, computation, and dimension (multiple variables) are not put together into a single column, but are separate.

Further, each observation forms a row. Each observation is the average of the measure for a given subject, activity, computation, and dimension.

Finally, each type of observational unit -- namely, the average values for a particular combination of subject, activity, measure, computation, and dimension -- forms our table.