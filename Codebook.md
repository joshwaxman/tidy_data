---
title: "Codebook"
author: "Joshua Waxman"
date: "Sunday, November 23, 2014"
output: html_document
---

##Source for the data
The data were originally obtained from "Human Activity Recognition Using Smartphones Dataset, Version 1.0", at this URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

That data contained a series of rows, each containing 561 different measurements. These were collected for 30 subjects performing 6 activities while wearing a Samsung smartphone.

This is how they described their acquisition of the data:

> Human Activity Recognition Using Smartphones Dataset
> Version 1.0
>
> Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
> Smartlab - Non Linear Complex Systems Laboratory
> DITEN - Università degli Studi di Genova.
> Via Opera Pia 11A, I-16145, Genoa, Italy.
> activityrecognition@smartlab.ws
> www.smartlab.ws
>
> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
>
> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 
>
> For each record it is provided:
>
> * Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
> * Triaxial Angular velocity from the gyroscope. 
> * A 561-feature vector with time and frequency domain variables. 
> * Its activity label. 
> * An identifier of the subject who carried out the experiment.

The input files are described in detail in our README.md. They also provided the following details as to their feature selection:

> The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
> 
> Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
> 
> Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc -XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note  the 'f' to indicate frequency domain signals). 
> 
> These signals were used to estimate variables of the feature vector for each pattern:  
> '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
> 
> * tBodyAcc-XYZ
> * tGravityAcc-XYZ
> * tBodyAccJerk-XYZ
> * tBodyGyro-XYZ
> * tBodyGyroJerk-XYZ
> * tBodyAccMag
> * tGravityAccMag
> * tBodyAccJerkMag
> * tBodyGyroMag
> * tBodyGyroJerkMag
> * fBodyAcc-XYZ
> * fBodyAccJerk-XYZ
> * fBodyGyro-XYZ
> * fBodyAccMag
> * fBodyAccJerkMag
> * fBodyGyroMag
> * fBodyGyroJerkMag
> 
> The set of variables that were estimated from these signals are: 
> 
> * mean(): Mean value
> * std(): Standard deviation

and a whole slew of others which our data manipulation removes, such that we will not mentioned them.

> Additional vectors obtained by averaging the signals in a signal window sample. These are used > on the angle() variable:
> 
> gravityMean
> tBodyAccMean
> tBodyAccJerkMean
> tBodyGyroMean
> tBodyGyroJerkMean

##Data manipulation
We manipulated these data in various ways. First, as mentioned above, we look only at the mean and std computations, omitting all other calculation columns. Next, we summarized these data by grouping by subject and activity and then taking the average of those mean and std calculations.

Finally, we tidied the data as follows: We gathered the columns into a key column called measure_computation_dimension and a value column called value. The measure_computation_dimension contained the name of the measure used, such as tBodyAcc-mean-X or tBodyAcc-mean-Y, and the value column contains the value that used to be in the field for that row and the column by the key name.

Then, we separated the measure_computation_dimension column into three columns, namely measure, computation, and dimension. Thus, for instance, a value of tBodyAcc-mean-Y became "tBodyAcc" for the measure, "mean" for the computation, and "Y" for the dimension.

Some measure_computation_dimensions only have a measure and computation but no dimension. For example, fBodyBodyGyroJerkMag-std has a measure of "fBodyBodyGyroJerkMag" and a computation of "std" but no dimension of "X", "Y", or "Z". In such a case, NA is assigned.
mean and std 

The R source code we used to modify the data is in the file run_analysis.R. Please look to the README.md file for a **detailed explanation** of how we modified the data as well as an explanation as to why the resulting data is "tidy".

##Variables
The tidy data contains the following variables, as columns:

* subject -- this is the number of the subject who performed the activity. There are 30 subjects.
* activity -- this is the activity the subject performed. There are six such activities: LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, and WALKING_UPSTAIRS.
* measure -- this is a description of the type of measurement taken by the smartphone when the activity was performed. There are 17 such measurements: tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk, tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag, fBodyAcc, fBodyAccJerk, fBodyGyro, fBodyAccMag, fBodyBodyAccJerkMag, fBodyBodyGyroMag, and fBodyBodyGyroJerkMag.
* computation -- for each of these measures, which computation was performed. The two values for this are mean and std (standard deviation).
* dimension -- many of these measures were taken in X, Y, and Z dimensions. The possible values are thus X, Y, and Z. If a given measurement does not involve a dimension, then the dimension is NA.
* value -- the actual value of the measurement in question.