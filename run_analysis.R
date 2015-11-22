# read the tables that contain test data, without the headers
subject_test<- read.table("./dataproject/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
X_test<- read.table("./dataproject/UCI HAR Dataset/test/X_test.txt", header = FALSE)
Y_test<- read.table("./dataproject/UCI HAR Dataset/test/y_test.txt", header = FALSE)

# read the tables that contain training data, without the headers
subject_train<- read.table("./dataproject/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
X_train<- read.table("./dataproject/UCI HAR Dataset/train/X_train.txt", header = FALSE)
Y_train<- read.table("./dataproject/UCI HAR Dataset/train/y_train.txt", header = FALSE)

# read the tables that contain the activity labels and features, without the headers
activity_labels<- read.table("./dataproject/UCI HAR Dataset/activity_labels.txt", header = FALSE)
features<- read.table("./dataproject/UCI HAR Dataset/features.txt", header = FALSE)

#add column names for each table in the training family
colnames(X_train)  <- features[,2] #use the column names present in the features table for each of the 561 variables
colnames(Y_train)  <- "activity" 
colnames(subject_train)  <- "subject"

#add column names for activity table
colnames(activity_labels)  <- c("id","type")

#add column names for each table in the test family
colnames(X_test)  <- features[,2] #use the column names present in the features table for each of the 561 variables
colnames(Y_test)  <- "activity" 
colnames(subject_test)  <- "subject"

# use column bind function to collate the training and test data into data frames
DF_train <- cbind(subject_train,Y_train,X_train)
DF_test <- cbind(subject_test,Y_test,X_test)

# use row bind function to stack the training and test data for all observations
DF <- rbind(DF_train, DF_test)

#check to ensure the correct column names appear for each column in the new data frame
names(DF)

# collects the columns where the keywords 'mean' or 'std' appear in the column header
meanstdcols <- grep("-(mean|std)\\(\\)",features[,2])

# picks out only the columns containing the keywords 'mean' or 'std' and adds to a new data frame
DF_trim <- subset(DF[,meanstdcols])
names(DF_trim) <- features[meanstdcols,2]
names(DF_trim)

#column binds subject and activity from the DF data frame to the DF_trim data frame
DF_trim <- cbind(DF$activity,DF_trim, DF$subject)

# assigns activity labels to each value in the activity column in the DF_trim data frame
DF_trim[,1] <- activity_labels[DF_trim[,1],2]

#edit column names for the activity and subject columns
colnames(DF_trim)[1] <- "activity"
colnames(DF_trim)[68] <- "subject"

install.packages("plyr")
library(plyr)
averages <- ddply(DF_trim,.(subject,activity), function(x) colMeans(x[,2:67])) 
averages

