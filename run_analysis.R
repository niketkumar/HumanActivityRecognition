rootFolder <- "UCI-HAR-Dataset"
tidySetFile <- "bySubjectByActivityMeans.txt"

masterFeatureFile <- paste(rootFolder,"/features.txt", sep="")
masterActivitiesFile <- paste(rootFolder,"/activity_labels.txt", sep="")
trainXFile <- paste(rootFolder,"/train/X_train.txt", sep="")
trainYFile <- paste(rootFolder,"/train/y_train.txt", sep="")
trainSubjectFile <- paste(rootFolder,"/train/subject_train.txt", sep="")
testXFile <- paste(rootFolder,"/test/X_test.txt", sep="")
testYFile <- paste(rootFolder,"/test/y_test.txt", sep="")
testSubjectFile <- paste(rootFolder,"/test/subject_test.txt", sep="")


#Load master Features
features <- read.table(masterFeatureFile, header=F, sep="", colClasses=c("numeric","character"))

#Prepare to build two vectors to select features related mean() and std() measurements only
#meanStdPattern <- "(\\-mean\\(\\)\\-)|(\\-std\\(\\)\\-)"
#lMeanStdFeatures <- grepl(meanStdPattern, features$V2)
meanStdPattern <- "mean|std)"
lMeanStdFeatures <- grepl(meanStdPattern, features$V2, ignore.case=T)
colNames <- features$V2[lMeanStdFeatures] #selected feature names
colClasses <- sapply(lMeanStdFeatures, function(l) ifelse(l, "numeric", "NULL")) #selected feature classes

#Load master activities
activities <- read.table(masterActivitiesFile, header=F, sep="", colClasses=c("numeric","character"))

#It loads X, y and subject files selecting only above mentioned features.
#It returns the data.frame with activity, mean/std features and subject.
loadData <- function(xFile, yFile, subjectFile) {
        X <- read.table(xFile, header=F, sep="", colClasses=colClasses)
        Y <- read.table(yFile, header=F, sep="", colClasses="numeric")
        subject <- read.table(subjectFile, header=F, sep="", colClasses="numeric")
        Y$desc <- sapply(Y$V1, function(a) activities$V2[activities$V1 == a])
        X <- cbind(subject$V1, Y$desc, X)
        names(X) <- tolower(c("subject", "activity", colNames))
        X
}
train <- loadData(trainXFile, 
                  trainYFile, 
                  trainSubjectFile)

test <- loadData(testXFile, 
                 testYFile, 
                 testSubjectFile)

data <- rbind(train, test) #merged data set

#Generating tidy set with per subject per activity: feature means
library(reshape2)
bySubjectByActivity <- melt(data, id.vars=names(data)[1:2], measure.vars=names(data)[3:length(names(data))])
bySubjectByActivityMeans <- dcast(bySubjectByActivity, subject + activity ~ variable, mean)
write.table(bySubjectByActivityMeans, tidySetFile, sep=" ", row.names=F)
