##Read in all the files for processing
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt") ##features are consistent across test and train data
##Change column headers to descriptive variables
features[,2] <- gsub("[()]", "", features[,2]) ##clean up special characters for column headers in next step
features[,2] <- gsub("std", "standard_deviation", features[,2])
features[,2] <- gsub("Freq", "_Frequency", features[,2])
features[,2] <- gsub("tBody", "time_body", features[,2])
features[,2] <- gsub("fBody", "frequency_body", features[,2])
features[,2] <- gsub("tGravity", "time_gravity", features[,2])
features[,2] <- gsub("Acc", "_Accelerometer", features[,2])
features[,2] <- gsub("Gyro", "_Gyroscope", features[,2])
features[,2] <- gsub("[-]", "_", features[,2])
for(i in extract_numeric(colnames(train))){
  y <- as.character(features[i,2])
  names(train)[i] <- y
  names(test)[i] <- y
}
##Combine test subject ID and activity names with test and train data
newtest <- cbind(rename(ytest, activity = V1), test) ##first column shares same name as first column in joined data.frame so renaming before binding
newtrain <- cbind(rename(ytrain, activity = V1), train)
combinedtest <- cbind(rename(subjecttest, subject_id = V1), newtest)
combinedtrain <- cbind(rename(subjecttrain, subject_id = V1), newtrain)
##Combine modified test and train data.frames
combineddata <- rbind(combinedtest, combinedtrain)
names(combineddata) <- unique(names(combineddata))
filtereddata <- combineddata[, grep("activity|subject_id|_mean|_std", names(combineddata))]
##convert activity id to descriptive name
activities <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
filtereddata$activity <- activities[filtereddata$activity]
##summarize data
summarizeddata <- group_by(filtereddata, subject_id, activity) %>% summarize_each(funs(mean))
write.table(summarizeddata, file = "summary.txt", row.names=FALSE)