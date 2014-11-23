---
title: "Codebook"
author: "Joshua Waxman"
date: "Sunday, November 23, 2014"
output: html_document
---

##Source for the data
The data were originally obtained from "Human Activity Recognition Using Smartphones Dataset, Version 1.0", at this URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

That data contained a of rows, each containing 561 different measurements. These were collected for 30 subjects performing 6 activities while wearing a Samsung smartphone.

##Data manipulation
We manipulated these data in various ways, by looking only at the mean and std computations, summarizing by grouping by subject and activity and then taking the average of those calculations, and finally tidying the data.

The R source code we used to modify the data is in the file run_analysis.R. Look to the README.md file for an explanation of how we modified the data as well as an explanation as to why the resulting data is "tidy".

##Variables
The tidy data contains the following variables, as columns:

* subject -- this is the number of the subject who performed the activity. There are 30 subjects.
* activity -- this is the activity the subject performed. There are six such activities: LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, and WALKING_UPSTAIRS.
* measure -- this is a description of the type of measurement taken by the smartphone when the activity was performed. There are 17 such measurements: tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk, tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag, fBodyAcc, fBodyAccJerk, fBodyGyro, fBodyAccMag, fBodyBodyAccJerkMag, fBodyBodyGyroMag, and fBodyBodyGyroJerkMag.
* computation -- for each of these measures, which computation was performed. The two values for this are mean and std (standard deviation).
* dimension -- many of these measures were taken in X, Y, and Z dimensions. The possible values are thus X, Y, and Z. If a given measurement does not involve a dimension, then the dimension is NA.
* value -- the actual value of the measurement in question.