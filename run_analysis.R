library(dplyr)
library(tidyr)
# read in the test data
obtain_data <- function(kind) {
  the_data <- read.table(sprintf("UCI HAR Dataset/%s/X_%s.txt", kind, kind), header = FALSE)
  column_names <- read.table("UCI HAR Dataset/features.txt", header=FALSE)
  subjects <- read.table(sprintf("UCI HAR Dataset/%s/subject_%s.txt", kind, kind), header = FALSE)
  names(subjects) <- c("subject")
  activities <- read.table(sprintf("UCI HAR Dataset/%s/y_%s.txt", kind, kind), header = FALSE)
  names(activities)=c("activity_number")
  activity_names <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
  names(activity_names) <- c("activity_number", "activity")
  
  # massage the column names to remove parentheses, etc
  column_names[[2]] <- gsub("\\(\\)", "", column_names[[2]])
  column_names[[2]] <- gsub("\\(dbl\\)", "", column_names[[2]])
  
  # assign the column names to the data
  names(the_data) <- column_names[[2]]
  # use grep to find columns which contain std or mean at word boundaries
  desired_columns <- grep("(std\\>)|(mean\\>)", column_names[[2]])
  # and filter for just those columns
  the_data <- the_data[, desired_columns]
  
  # inner join activities with activity names
  t <- (
    inner_join(activities, activity_names, by="activity_number") %>%
      select(activity)
  )
  
  # bring in the activities as second column to the_data
  t <- cbind(t, the_data)
  
  # bring in the subjects as first column to the_data
  t <- cbind(subjects, t)
    
  t
}

# function get_averages takes in the data frame and computes the averages
# of the std and mean fields
get_averages <- function(t) {
  t <- group_by(t, subject, activity)
  t <- summarise_each(t, funs(mean))
}

tidy_data <- function(t) {
  t <- gather(t, measure_computation_dimension, value, -(1:2))
  
  # certain of these measure_computation_dimension values lack a dimension
  # so to allow the separate to work, will add an NA as a string
  t$measure_computation_dimension <- gsub("(\\w+-)mean$", "\\1mean-NA", t$measure_computation_dimension)
  t$measure_computation_dimension <- gsub("(\\w+-)std$", "\\1std-NA", t$measure_computation_dimension)    
  
  t <- separate(t, measure_computation_dimension, c("measure", "computation", "dimension"))
  
  # finally, fix those "NA" string values in the dimension column into actual NAs
  t$dimension[t$dimension == "NA"] = NA

  t
}

process_data <- function() {
  # obtain the test and training data and combine them
  test_data <- obtain_data("test")
  train_data <- obtain_data("train")
  total_data <- rbind(test_data, train_data)
  
  # get the averages of the std and mean fields 
  # in format which what might be considered "messy"
  total_data <- get_averages(total_data)
  
  total_data <- tidy_data(total_data)
  # tidy the data 
  total_data
}




