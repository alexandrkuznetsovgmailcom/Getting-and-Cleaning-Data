#Load librarys
library(dplyr)

#Load all files

#Load features.txt
features <- read.table("./UCI HAR Dataset/features.txt")

#Load activity_labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Load test data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",colClasses="numeric")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt",colClasses="numeric")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",colClasses="numeric")

#Load train data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",colClasses="numeric")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt",colClasses="numeric")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",colClasses="numeric")

#Merge activity label
y_test <- merge(y_test,activity_labels,by.x="V1",by.y="V1")
y_train <- merge(y_train,activity_labels,by.x="V1",by.y="V1")

#Set column names from "features" dataframe to features
names(X_test) <- features[,2]
names(X_train) <- features[,2]

#Set column names for activity
names(y_test) <- c("Id","Label")
names(y_train) <- c("Id","Label")

#Set
names(subject_test) <- c("Subject")
names(subject_train) <- c("Subject")

#Bing subject amd activity
SubjectAndActitvityTest <- cbind(subject_test,Activity = y_test[,2])
SubjectAndActitvityTrain <- cbind(subject_train,Activity = y_train[,2])

#Bind test and training SubjectAndActitvitys data
full_SubjectAndActitvity <- rbind(SubjectAndActitvityTest,SubjectAndActitvityTrain)


#Bind test and training features data
full_features <- rbind(X_test,X_train)

#Extract only mean and standard deviation for each measurement
#Ignore meanFreq
full_extract_features <- full_features[,grepl("-mean()",names(full_features),fixed = TRUE) | 
                                                   grepl("-std()",names(full_features),fixed = TRUE)]

#Bind full data
full_ds <- cbind(full_SubjectAndActitvity,full_extract_features)


#Transform data
resultMelt <- melt(full_ds,id=c("Subject","Activity"),measure.vars=colnames(select(full_ds,-Activity,-Subject)))
resultData <- dcast(resultMelt,Subject + Activity ~ variable,mean)

#Sort data
resultData <- arrange(resultData,Subject,Activity)


#Write file
write.table(resultData,"result.txt",row.names = FALSE)