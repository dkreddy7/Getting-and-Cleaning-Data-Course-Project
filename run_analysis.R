# Read X_test.txt
x_test <- read.csv("UCI HAR Dataset/test/X_test.txt",sep="",header=FALSE)

# Read y_test.txt
y_test <- read.csv("UCI HAR Dataset/test/y_test.txt",sep="",header=FALSE)

# Read subject_test.txt
subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt",sep="",header=FALSE)

# Read X_train.txt
x_train <- read.csv("UCI HAR Dataset/train/X_train.txt",sep="",header=FALSE)

# Read y_train.txt
y_train <- read.csv("UCI HAR Dataset/train/y_train.txt",sep="",header=FALSE)

# Read subject_train.txt
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt",sep="",header=FALSE)

# Merging test datasets
merge_test <- data.frame(subject_test, y_test, x_test)

# Merging train datasets
merge_train <- data.frame(subject_train, y_train, x_train)

# Merge training and test datasets
merged_data <- rbind.data.frame(merge_train, merge_test)

# Read column labels
features <- read.csv("UCI HAR Dataset/features.txt",sep="",header=FALSE)

# Read activity labels
activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)

# Label columns
colnames(merged_data) <- c("subject","column_y",as.vector(features[,2]))

# Extract mean and standard deviation columns
merged_data <- select(merged_data,contains("subject"),contains("column_y"),contains("mean"),contains("std"))

# Fix variable names
merged_data$activity_labels <- as.character(activity_labels[match(merged_data$activity_labels,activity_labels$V1),'V2'])
setnames(merged_data, colnames(merged_data), gsub("\\(\\)", "", colnames(merged_data)))
setnames(merged_data, colnames(merged_data), gsub("-", "_", colnames(merged_data)))
setnames(merged_data, colnames(merged_data), gsub("BodyBody", "Body", colnames(merged_data)))

write_data <- merged_data %>% group_by(subject, column_y) %>% summarise_each(funs(mean))

# Write data
write.table(write_data, file="run_analysis.txt", row.name=FALSE)
