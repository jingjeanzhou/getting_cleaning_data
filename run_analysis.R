# load libraries that will be needed
library(dplyr)
library(data.table)
library(tidyr)

# download the zipfile and save into the Rproject folder in current WD. 

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./Rproject/wearabletechdata.zip")

# unzip the zipfile and set the file to variable datafile 
unzip(zipfile = "./R/wearabletechdata.zip")
datafile <- "UCI HAR Dataset"

#read data files into R and give column names whereever possible
activities_lables <- read.table(paste(datafile, "activity_labels.txt", sep = "/"), col.names = c("Activity.ID", "Activity.Name"))
features <- read.table(paste(datafile, "features.txt", sep = "/"), col.names = c("Feature.Number", "Feature.Name"))
y_test <- read.table(paste(datafile, "test", "y_test.txt", sep = "/"), col.names = "Activity.ID")
y_train <- read.table(paste(datafile, "train", "y_train.txt", sep = "/"), col.names = "Activity.ID")
x_test <- read.table(paste(datafile, "test", "x_test.txt", sep = "/"))
x_train <- read.table(paste(datafile, "train", "x_train.txt", sep = "/"))
subject_test <- read.table(file = paste(datafile, "test", "subject_test.txt", sep="/"), col.names="Subject")
subject_train <- read.table(file = paste(datafile, "train", "subject_train.txt", sep="/"), col.names="Subject")

#combine files from the test and train folders, add column names to the data file (x files)

combsubject <- rbind(subject_train, subject_test)
combactivity <- rbind(y_train, y_test)
combdata <- rbind(x_train, x_test)
colnames(combdata) <- features$Feature.Name

combactivitydata <- merge(combactivity, activities_lables, by.x = "Activity.ID", by.y = "Activity.ID")
Activity.Name <- combactivitydata[,2]

#find only columns that are only mean or standard deviation
meanandstd <- data[, c("Subject", "Activity.Name", grep("mean|std", colnames(data), value=TRUE))]

#melt by subject / activity
subactdata <- melt (meanandstd, id.vars = c("Subject", "Activity.Name"))

#cast the data by subject/activity and calculate the average of the variables 
tidydata     <- dcast(sub_act_data, Subject + Activity.Name ~ variable, mean)

# write final data to file 
write.table(tidydata, row.name=FALSE, file = "tidy_data.txt") 


