#Load data into R
X_train <- read.table("X_train.txt")
Y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")
X_test <- read.table("X_test.txt")
Y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")
#Merge different observations on the same variables from train set and test set
DF <- rbind(X_train, X_test)
#Load "features.txt" into R
features <- read.table("features.txt")
#Give appropriate name to each variable
colnames(DF) <- features[,2]
#Merge activities from train set and test set
myData <- rbind(Y_train, Y_test)
#Merge subjects from train set and test set
myData2 <- rbind(subject_train, subject_test)
#Merge activities with appropriate values of different variables
DF <- cbind(myData, DF)
#Merge subjects with previous data frame
DF <- cbind(myData2, DF)
#Extract only columns corresponding to subjects, activities and mean or standard deviation of measurements
DF <- DF[, c(1, 2, grep("mean\\()|std()", colnames(DF)))]
#Rename column to be more descriptive
colnames(DF)[2] <- "activity"
#Load "car" package
library(car)
#Rename activity names to be descriptive, according to the "activity_labels.txt"
DF$activity <- recode(DF$activity, "1='WALKING';2='WALKING_UPSTAIRS';3='WALKING_DOWNSTAIRS';4='SITTING';5='STANDING';6='LAYING'")
#Rename column to be more descriptive
colnames(DF)[1] <- "subject"
#Replace abbreviations in column names with full words, in order to be understandable
sub("Acc", "Accelerometer", colnames(DF), fixed = TRUE)
sub("Gyro", "Gyroscope", colnames(DF), fixed = TRUE)
sub("^t", "Time", colnames(DF))
sub("^f", "Frequency", colnames(DF))
#Load "dplyr" package
library(dplyr)
#Create new data frame called "newDF" which consists of data from data frame "DF" and calculate the average of each measurement for each activity and subject
newDF <- DF %>% group_by(activity, subject) %>% summarise_each(funs(mean))
#Print newDF
newDF