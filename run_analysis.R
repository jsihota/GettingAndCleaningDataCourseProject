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


# Get train and subject data 
filename  = "train"
prefix <- paste(filename, '/', sep = '')
testData <- paste(prefix, 'X_', filename, '.txt', sep = '')
testLabel <- paste(prefix, 'y_', filename, '.txt', sep = '')
testSubject <- paste(prefix, 'subject_', filename, '.txt', sep = '')
data <- read.table(testData)[, features$index]
names(data) <- features$name
label <- read.table(testLabel)[, 1]
data$label <- factor(label, levels=labels$level, labels=labels$label)
subject <- read.table(testSubject)[, 1]
data$subject <- factor(subject)
trainData <- data.table(data)

#Get train data 
filename  = "train"
prefix <- paste(filename, '/', sep = '')
testData <- paste(prefix, 'X_', filename, '.txt', sep = '')
testLabel <- paste(prefix, 'y_', filename, '.txt', sep = '')
testSubject <- paste(prefix, 'subject_', filename, '.txt', sep = '')
data <- read.table(testData)[, features$index]
names(data) <- features$name
label <- read.table(testLabel)[, 1]
data$label <- factor(label, levels=labels$level, labels=labels$label)
subject <- read.table(testSubject)[, 1]
data$subject <- factor(subject)
testData <- data.table(data)

# combine data set 
combinedDataDet <- rbind(trainData, testData)

#clean up 
#Appropriately labels the data set with descriptive variable names
tidyDataset <- combinedDataDet[, lapply(.SD, mean), by=list(label, subject)]
# Fix the variable names
names <- names(tidyDataset)
names <- gsub('[()-]', '', names) 
names <- gsub('BodyBody', 'Body', names)
names <- gsub('-mean', 'MEAN', names)
names <- gsub('-std', 'STD', names) 

setnames(tidyDataset, names)
setwd('..')
write.csv(tidyDataset, file = 'TidyDataSet.txt',row.names = FALSE, quote = FALSE)

