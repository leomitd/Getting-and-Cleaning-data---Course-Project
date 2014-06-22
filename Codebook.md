# Introduction

The analysis aimed to get and clean the data from the UCI Machine Learning Repository which records the values of the accelerometer measured on 30 different
subjects while performing activities of daily living (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)

# Original data

## The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set. Composed of 561 different columns, listed in features.txt

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set. Composed of 561 different columns, listed in features.txt

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

## Variables (Features)

The features selected for this database come from the accelerometer and gyroscope 3-axial 
raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. 
Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. 
Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). 
Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, 
fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

# Steps undertaken by the analysis script

## Goal

The aim of this analysis is to create a tidy data set which contains contains 
the mean of both, mean() and std() -standard deviation- variables of the raws files, for each activity and each subject

# Data transformation

### Downloading the data and selecting right features

Downloading and unzipping the files onto the local computer

```
fileURL1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileURL1, destfile = "UCI_HAR_Dataset.zip", method = "curl")
unzip("UCI_HAR_Dataset.zip")
```

The files are unzipped in the *UCI HAR Dataset/* directory
We then create the different local variables containing the paths to the different files (mentioned in the section **Original data** above).

```
#Training data paths
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
```

As our analysis focuses only on the mean() and std() variables, before loading the data we select the corresponding columns' indexes.
We also clean the names by removing all special characters. This aims to use the columns names as R selectors

```
#Features data
dataFeatures <- read.table(features, stringsAsFactors = F)

#Select index only mean and std
indexMeanStd <- grep("mean|std",dataFeatures$V2)
#Select column names of mean and Std
meanStdFeat  <- dataFeatures$V2[indexMeanStd]

#Replace special special characters
meanStdFeat<- gsub("[()]","",meanStdFeat)
meanStdFeat<- gsub("[-+,]","_",meanStdFeat)
```
	
### Loading the data into the R environment
```
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

##Subject and y Test data
dataSubTest <-  read.table(subject_test)
datayTest <- read.table(y_test)

#X Test data and selection of the Means and Stds only
dataXTest <- read.table(X_test)
dataXTest <- dataXTest[,indexMeanStd]

##Create one Test data set
TestDataSet <- cbind(dataSubTest,datayTest,dataXTest)
```

Creating data set that combines both Test and Train data
```
finalDataSet <- rbind(TrainDataSet,TestDataSet)
```

Labeling the columns of the dataset
```
colnames(finalDataSet) <- c("Subject","Act",meanStdFeat)
```

In order to combine all data provided, we decided to merge the dataset containing all the measurement with the one containing the activities labels.
```
mergedData <- merge(finalDataSet, dataActLabel, by.x = "Act", by.y ="V1")
#Change the name of the merged column from V2 to "Activity_Name"
names(mergedData)[names(mergedData) == "V2"] <- "Activity_Name"
```

### Create final tidy data set containing the mean of all variables
We have added "Mean_of_" in front of each variable names to give them a more descriptive aspect
```
finalTidySet <- ddply(mergedData, .(Subject, Activity_Name),  numcolwise(mean))

#Rename correctly the columns
colnames(finalTidySet)[4:82] <- paste("Mean_of",colnames(finalTidySet)[4:82], sep="_")
```

We then create the file containing the clean data set
```
write.table(finalTidySet, file="FinalTidySet_CourseProject.txt", sep=",")
```

# Output

The script will create a file called *FinalTidySet_CourseProject.txt* which is a comma separated file

Also the script will read print out the first 7 colmumns of the first 6 lines of the produced file in order to display the results

```
> head(readFinalTidySet[,1:7])
  Subject      Activity_Name Act Mean_of_tBodyAcc_mean_X Mean_of_tBodyAcc_mean_Y Mean_of_tBodyAcc_mean_Z Mean_of_tBodyAcc_std_X
1       1             LAYING   6               0.2215982            -0.040513953              -0.1132036            -0.92805647
2       1            SITTING   4               0.2612376            -0.001308288              -0.1045442            -0.97722901
3       1           STANDING   5               0.2789176            -0.016137590              -0.1106018            -0.99575990
4       1            WALKING   1               0.2773308            -0.017383819              -0.1111481            -0.28374026
5       1 WALKING_DOWNSTAIRS   3               0.2891883            -0.009918505              -0.1075662             0.03003534
6       1   WALKING_UPSTAIRS   2               0.2554617            -0.023953149              -0.0973020            -0.35470803
```





