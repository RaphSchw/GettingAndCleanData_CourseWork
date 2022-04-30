## You should create one R script called run_analysis.R that does the following: 
##
## Merges the training and the test sets to create one data set.
##
## Extracts only the measurements on the mean and standard deviation for each measurement.
##
## Uses descriptive activity names to name the activities in the data set
##
## Appropriately labels the data set with descriptive variable names.
##
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

library(dplyr)
library(tibble)
library(stringr)
library(reshape2)
library(rlog)

log_debug("Scanning whether files are installed and maybe installing")
if(!file.exists("./data")){dir.create(path = "./data")} ##Create the data directory if not done already
if(!file.exists("./data/sources.zip")){download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./data/sources.zip")} ##Download data if not done already
if(!file.exists("./data/UCI HAR Dataset")){unzip(zipfile = "./data/sources.zip", exdir = "./data")} ##Unzip data into /data if not done already
log_debug("Data folder is created and data downloaded")
path_x_test <- "./data/UCI HAR Dataset/test/X_test.txt"
path_x_train <- "./data/UCI HAR Dataset/train/X_train.txt"

log_debug("Reading in the test data")
df_test <- read.table(file = path_x_test)
log_debug("Tibble created for test data")

log_debug("Reading in the train data")
df_train <- read.table(file = path_x_train)
log_debug("Tibble created for train data")

log_debug("Reading in feature names and adding to the tibble")
path_feature_names <- "./data/UCI HAR Dataset/features.txt"
feature_names <- read.table(path_feature_names)$V2
names(df_test) <- feature_names
names(df_train) <- feature_names

log_debug("Reading in the test participants and adding to tibble")
path_test_participants <- "./data/UCI HAR Dataset/test/subject_test.txt"
test_participants <-as.numeric(scan(path_test_participants, what="", sep="\n"))
df_test$participant <- test_participants
df_test$set <- "test"

log_debug("Reading in the train participants and adding to tibble")
path_train_participants <- "./data/UCI HAR Dataset/train/subject_train.txt"
train_participants <-as.numeric(scan(path_train_participants, what="", sep="\n"))
df_train$participant <- train_participants
df_train$set <- "train"

path_labels_descriptive <- "./data/UCI HAR Dataset/activity_labels.txt"
activity_labels <- read.table(path_labels_descriptive, col.names = c("number", "understandable")) ##Create a mapping table between the activity numbers and names

path_test_labels <- "./data/UCI HAR Dataset/test/y_test.txt"
test_labels <- scan(path_test_labels, what="", sep="\n") ##Read the labels document in
df_test$activity <- test_labels

path_train_labels <- "./data/UCI HAR Dataset/train/y_train.txt"
train_labels <- scan(path_train_labels, what="", sep="\n") ##Read the labels document in
df_train$activity <- train_labels

log_debug("Merge train and test data and melt it down")
df_merged <- rbind(df_train, df_test)
df_merged <- df_merged %>% select(names(df_merged)[grepl(names(df_merged), pattern = "((mean\\(\\)|std\\(\\))|activity|participant|set)")]) ##Remove the columns, which do not concern std or mean measurements
log_debug(unique(df_merged$set)); log_debug(ncol(df_merged)) ##A little verificatio that there was no loss during the merger process
df_merged <- melt(df_merged, id.vars = c("activity", "set", "participant")) ##Melt down the data frame to make it long
log_debug(unique(df_merged$set)); log_debug(length(unique(df_merged$variable))) ##A little verificatio that there was no loss during the melting process

log_debug("Give specific acivity names")
df_merged$activity <- lapply(df_merged$activity, function(y) as.character(activity_labels$understandable[activity_labels$number == y])) ##Use the earlier created dataframe "activity_labels" to map the activity IDs to their names 
df_merged$activity <- as.character(df_merged$activity)

log_debug('Create tidy data set')
df_clean <- df_merged %>% group_by(set, participant,activity, variable) %>% summarise(mean_value = mean(value)) ##Extract the mean for the original measurements
df_clean <- df_clean %>% mutate(measurement = str_extract(variable, pattern = "(mean|std)"),dimension = str_extract(variable, pattern = "(X|Y|Z)$")) ##from this line on we are basically just splitting up the original column names to make sure that there is not one column with multiple variables and stay in line with tidy data
df_clean <- df_clean %>% mutate(variable = gsub(pattern = "-(mean\\(\\)|std\\(\\))-?(X|Y|Z)?", replacement = "", x = variable))
df_clean <- df_clean %>% mutate(acceleration_signal = str_extract(variable, pattern = "(Body|Gravity)"), sensor_signal = str_extract(variable, pattern = "(Acc|Gyro)"))

df_clean$jerk_signal <- lapply(df_clean$variable, function(y) if(str_detect(string = y, pattern = "Jerk")==TRUE){"yes"}else{NA})
df_clean$jerk_signal <- as.character(df_clean$jerk_signal)

df_clean$magnitude <- lapply(df_clean$variable, function(y) if(str_detect(string = y, pattern = "Mag")==TRUE){"yes"}else{NA})
df_clean$magnitude <- as.character(df_clean$magnitude)

df_clean$time_signal <- as.character(lapply(df_clean$variable, function(y) if(substr(y, start = 1, stop = 1)=="t"){"yes"}else{NA}))
df_clean$frequency_signal <- as.character(lapply(df_clean$variable, function(y) if(substr(y, start = 1, stop = 1)=="f"){"yes"}else{NA}))

df_clean <- df_clean %>% select(-variable) ##Remove the column with the original data names