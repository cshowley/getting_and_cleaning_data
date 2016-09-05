# Only pull features that explicitly calculate mean() and std() functions
features <- read.table('UCI HAR Dataset/features.txt')
mean_indices <- grep('mean()', features$V2, fixed=TRUE)
std_indices <- grep('std()', features$V2, fixed=TRUE)
feature_list <- sort(c(mean_indices, std_indices))

# Import test data w/ prespecified mean and std indices
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')
X_test <- read.table('UCI HAR Dataset/test/X_test.txt')[feature_list]
y_test <- read.table('UCI HAR Dataset/test/y_test.txt')
# Combine 3 tables into a single test table
test <- cbind(subject_test, y_test, X_test)

# Repeat the process for training data
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')
X_train <- read.table('UCI HAR Dataset/train/X_train.txt')[feature_list]
y_train <- read.table('UCI HAR Dataset/train/y_train.txt')
train <- cbind(subject_train, y_train, X_train)

# Combine test and training data and give columns descriptive names
all_data <- rbind(test, train)
colnames(all_data) <- c('Subject','Activity', as.character(features[feature_list, 2]))

# Change activity IDs to descriptive titles
activity_types <- read.table("UCI HAR Dataset/activity_labels.txt")
all_data$Activity <- factor(all_data$Activity, levels = activity_types[,1], labels = as.character(activity_types[,2]))
all_data$Subject <- as.factor(all_data$Subject)

tmp <- melt(all_data, id = c("Subject", "Activity"))
# Calculate means for all unique Subject/Activity pairs
results <- dcast(tmp, Subject + Activity ~ variable, mean)

write.table(results, "results.txt", row.names=FALSE, quote=FALSE)