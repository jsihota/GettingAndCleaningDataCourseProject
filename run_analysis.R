library(data.table)

#download and extract file to working directory 
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
filename <- 'dataset.zip'
download.file(url, destfile = filename, method = 'auto')
unzip(filename)

#set wd to extracted file folder 
subdir <- paste(getwd() ,"/UCI HAR Dataset", sep="")
setwd(subdir)
getwd()

# Get the features
feature <- read.table('features.txt', col.names = c('index', 'name'))
features <- subset(feature, grepl('-(mean|std)[(]', feature$name))
# Get the labels
labels <- read.table('activity_labels.txt', col.names = c('level', 'label'))


# Get training  data 
data <- read.table("./train/X_train.txt")[, features$index]
names(data) <- features$name
label <- read.table("./train/y_train.txt")[, 1]
data$label <- factor(label, levels=labels$level, labels=labels$label)
subject <- read.table("./train/subject_train.txt")[, 1]
data$subject <- factor(subject)
trainData <- data.table(data)

#Get test data 
data <- read.table("./test/X_test.txt")[, features$index]
names(data) <- features$name
label <- read.table("./test/y_test.txt")[, 1]
data$label <- factor(label, levels=labels$level, labels=labels$label)
subject <- read.table("./test/subject_test.txt")[, 1]
data$subject <- factor(subject)
testData <- data.table(data)

# combine data set 
combinedDataDet <- rbind(trainData, testData)
tidyDataset <- combinedDataDet[, lapply(.SD, mean), by=list(label, subject)]
#clean up 
#Appropriately labels the data set with descriptive variable names
names <- names(tidyDataset)
names <- gsub('[()-]', '', names) 
names <- gsub('BodyBody', 'Body', names) 
names <- gsub('-mean', 'Mean', names) 
names <- gsub('-std', 'Std', names) 

setnames(tidyDataset, names)

write.csv(tidyDataset, file = 'TidyDataSet.csv',row.names = FALSE, quote = FALSE)
# print dataset info
getwd()
ncol(tidyDataset) 
nrow(tidyDataset)
colnames( tidyDataset )
head(tidyDataset)

