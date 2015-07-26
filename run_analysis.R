#### This code is for the course project of the Coursera course module 3 "Getting & Cleaning Data" 

 
 
install.packages("reshape2") 
library(reshape2) 

 
######### Set working variable and folder ######### 

 
setwd("/Users/sy.kong/Desktop/S/UCI HAR Dataset") 
 
 
 ######### Read in train & test data ######### 
 
 
 ## Train data using subject_train.txt
subject_train <- read.csv("train/subject_train.txt", header = FALSE) 
X_train <- read.csv("train/X_train.txt", sep = "", header = FALSE) 
y_train <- read.csv("train/y_train.txt", header = FALSE) 

 
## Test data 
subject_test <- read.csv("test/subject_test.txt", header = FALSE) 
X_test <- read.csv("test/X_test.txt", sep = "", header = FALSE) 
 y_test <- read.csv("test/y_test.txt", header = FALSE) 
 
 
 ######### 4) Add column names X_train & X_test ######### 
 X_labels <- read.csv("features.txt", sep = "", header = FALSE) 
 X_labels <- X_labels[, 2] 
 
 ## Train data 
 colnames(X_train) <- X_labels 
 
 
 ## Test data 
 colnames(X_test) <- X_labels 
  
######### 3) Add factor level labels to y_train & y_test ######### 
 activity_labels <- read.csv("activity_labels.txt", sep = "", header = FALSE) 
 activity_labels <- activity_labels[, 2] 
 
 
 ## Train data 
 colnames(y_train) <- c("Activity") 
 y_train$Activity <- as.factor(y_train$Activity) 

 ## Change the variable to a factor 
 levels(y_train$Activity) <- activity_labels 

 ## Assign factor level names  
 
 ## Test data 
 colnames(y_test) <- c("Activity") 
 y_test$Activity <- as.factor(y_test$Activity) 

 ## Change the variable to a factor 
 levels(y_test$Activity) <- activity_labels 
 ## Assign factor level names 
 
 
 ######### 2) Extract subset of X_train & X_test with variables for mean and sd ######### 
 
 
indices <- grep("mean\\(\\)|std\\(\\)", names(X_train)) 

## \\ is an escape character that makes sure that grep looks for the "(" and then another \\ makes sure that grep 

looks for the ")" 
 ## | ensures grep looks for mean() OR std() 

 
## Train data 
 X_train_subset <- X_train[, indices] 
 
 
 ## Test data 
 X_test_subset <- X_test[, indices] 

 ######### 1) Merge train and test data ######### 

 
## Name variable in subject data sets "Subject" 
colnames(subject_train) <- c("Subject") 
 colnames(subject_test) <- c("Subject") 

 ## Merge train data 
Train_data <- cbind(subject_train, y_train, X_train_subset) 
 
 
 ## Merge test data 
Test_data <- cbind(subject_test, y_test, X_test_subset) 
 
 
## Merge test & train data 
Complete_data <- rbind(Train_data, Test_data) 

 
######### 5) Create tidy data set from Complete_data ######### 
 
 
## Make Subject and Activity variables factors 
 Complete_data$Subject <- as.factor(Complete_data$Subject) 
 
 
 ## Identify measure variables 
 measures <- names(Complete_data) 
 measures <- measures[3:68] 
 
 
 ## Melt data frame 
 Complete_melt <- melt(Complete_data, id = c("Subject", "Activity"), measure.vars = measures) 

 
 ## Cast data frame 
Complete_cast <- dcast(Complete_melt, Subject + Activity ~ variable, mean) 
 
 
## tidy data 
tidy <- Complete_cast 
write.table(tidy, "tidy.txt", row.names=FALSE, sep=",") 
