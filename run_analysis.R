# I assume resphape2 is installed before running this  code.
library(reshape2)
#read subject name for the data set
feature <- read.table("./UCI HAR Dataset/features.txt")

#read test data from X_test.txt file and add subject name to it
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(test) <- feature[,2]
#head(test)

#read activity ID for test data and add subject name
test_aID <- read.table("./UCI HAR Dataset/test/y_test.txt")
colnames(test_aID) <- "actID"

#read subject id for test data 
test_sID <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(test_sID) <- "subID"

#use cbind to add actID and subID to test data
test_dt <- cbind(test_sID,test_aID,test)
#dim(test_dt)
#head(test_dt)
#summary(test_dt)

#read train data from X_train.txt file and add subject names to it.
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(train) <- feature[,2]


#read activity id for train data
train_aID <- read.table("./UCI HAR Dataset/train/y_train.txt")
colnames(train_aID) <- "actID"

#read subject id for train data
train_sID <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(train_sID) <- "subID"

#use cbind to add actID and subID to train data
train_dt <- cbind(train_sID,train_aID,train)

#combine the test and train data set
dt <- rbind(train_dt,test_dt)

#dim(dt)
#head(dt)
#summary(dt)

#filter the columns that contains std and mean keywords
i <- grep("std|mean",names(dt),ignore.case=T)
col_names <- names(dt)[i]

# subset the data set that contains subID, actID, std and mean
new_dt <- dt[,c("subID","actID",col_names)] 

#read the activity label and add subject names
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(labels) <- c("actID","actName")

#merge the labels and new_dt
merge_dt <- merge(labels,new_dt,by.x="actID",by.y="actID",all=T)
#head(merge_dt)
#tail(merge_dt)

# melt the data to define the ID variable.
melt_dt <- melt(merge_dt,c("actID","actName","subID"))

#dcast to reshape the given data set.
dcast_dt <- dcast(melt_dt,actID + actName + subID ~ variable, mean)

#write down the output value to a file.
write.table(dcast_dt,"./tidy_data.txt")

