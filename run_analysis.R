##########################################################################################################

# Coursera Getting and Cleaning Data Course Project
# Léo Souquet
# 22/07/2013

# This script will does the following steps : 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#Date set source : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##########################################################################################################

#Load library
library(plyr)

#Get the file URL
fileURL1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download the data file and unzip the file
download.file(fileURL1, destfile = "UCI_HAR_Dataset.zip", method = "curl")
unzip("UCI_HAR_Dataset.zip")


##Traing data paths
train <- "UCI HAR Dataset/train/"
subject_train <- paste(train,"subject_train.txt",sep="")
X_train <- paste(train,"X_train.txt", sep="")
y_train <- paste(train, "y_train.txt",sep="")

#Test data paths
test <-"UCI HAR Dataset/test/"
subject_test <- paste(test,"subject_test.txt",sep="")
X_test <- paste(test,"X_test.txt",sep="")
y_test <- paste(test,"y_test.txt",sep="")

#Features
features <- "UCI HAR Dataset/features.txt"

#Activities labels
activities_labels <- "UCI HAR Dataset/activity_labels.txt"

#*************Load data*************

#Features data
dataFeatures <- read.table(features, stringsAsFactors = F)

#Select index only mean and std
indexMeanStd <- grep("mean|std",dataFeatures$V2)
#Select column names of mean and Std
meanStdFeat  <- dataFeatures$V2[indexMeanStd]

#Replace special special characters
meanStdFeat<- gsub("[()]","",meanStdFeat)
meanStdFeat<- gsub("[-+,]","_",meanStdFeat)

#Activities Label data
dataActLabel <- read.table(activities_labels)

#Subject and y Train data
dataSubTrain <- read.table(subject_train)
datayTraing <- read.table(y_train)

#X Train data and selection of the Means and Stds only
dataXTrain <- read.table(X_train)
dataXTrain <- dataXTrain[,indexMeanStd]

##Create one train data set
TrainDataSet <- cbind(dataSubTrain,datayTraing,dataXTrain)

##Remove Train temporary variable from the memory
remove(dataSubTrain,dataXTrain,datayTraing)

##Subject and y Test data
dataSubTest <-  read.table(subject_test)
datayTest <- read.table(y_test)

#X Test data and selection of the Means and Stds only
dataXTest <- read.table(X_test)
dataXTest <- dataXTest[,indexMeanStd]

##Create one Test data set
TestDataSet <- cbind(dataSubTest,datayTest,dataXTest)

##Remove Test temporary variable from the memory
remove(dataSubTest,dataXTest,datayTest)

##Create final data fram, combine Train and Test variable
finalDataSet <- rbind(TrainDataSet,TestDataSet)

##Remove temporary Test and Train data set
remove(TrainDataSet,TestDataSet)

##Name the columns
colnames(finalDataSet) <- c("Subject","Act",meanStdFeat)

##Merge the data set with the activities label
mergedData <- merge(finalDataSet, dataActLabel, by.x = "Act", by.y ="V1")

#Name the new column
names(mergedData)[names(mergedData) == "V2"] <- "Activity_Name"

#Create the second dataset with the average of each variable for each activity and each subject.
#finalTidySet <- aggregate(mergedData[1:81], by=list(mergedData$Subject,mergedData$Activity_Name), FUN=mean)
finalTidySet <- ddply(mergedData, .(Subject, Activity_Name),  numcolwise(mean))

#Rename correctly the columns
colnames(finalTidySet)[4:82] <- paste("Mean_of",colnames(finalTidySet)[4:82], sep="_")

#Create final tiday data set file
write.table(finalTidySet, file="FinalTidySet_CourseProject.txt", sep=",")

#Read the file to check
readFinalTidySet <- read.table("FinalTidySet_CourseProject.txt", header = T, sep=",")

#Display the head
head(readFinalTidySet[,1:7])
