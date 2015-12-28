## Step # 1
## Read all of the source data
    test.labels    <- read.table("test/y_test.txt", col.names="label")
    test.subjects  <- read.table("test/subject_test.txt", col.names="subject")
    test.data      <- read.table("test/X_test.txt")
    train.labels   <- read.table("train/y_train.txt", col.names="label")
    train.subjects <- read.table("train/subject_train.txt", col.names="subject")
    train.data     <- read.table("train/X_train.txt")

## Aggregate the data
    data <- rbind(cbind(train.subjects, train.labels, train.data), cbind(test.subjects, test.labels, test.data))

## Step # 2
## Read all of the features
    features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
## Only retain features of mean and standard deviation
    features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

## Select only the means and standard deviations from data
## Increment by 2 since source data has subjects and labels in the beginning
    data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

## Step 3
## Read the labels (activities)
    labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
## Replace labels in data with label names
    data.mean.std$label <- labels[data.mean.std$label, 2]

## Step 4
## First, make a list of the current column names and feature names
    good.colnames <- c("subject", "label", features.mean.std$V2)
## Next, tidy that list by removing every non-alphabetic character and converting to lowercase
    good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))

## Lastly, use the list as column names for data
    colnames(data.mean.std) <- good.colnames

## Step 5
## find the mean for each combination of subject and label
    aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

## Step 6: Create the Tidy2.txt output file of tidy data
    write.table(format(aggr.data, scientific=T), "Tidy2.txt",
            row.names=FALSE, col.names=F, quote=2)