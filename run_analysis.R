#Set working directory
setwd("/Users/ashleysharp/Dropbox/R/Coursera/gettingcleaning/UCI HAR Dataset")

#Read the data into R
x_test <- read.table("test/X_test.txt", header=FALSE)
y_test <- read.table("test/y_test.txt", header=FALSE)
subject_test <- read.table("test/subject_test.txt", header=FALSE)
x_train <- read.table("train/X_train.txt", header=FALSE)
y_train <- read.table("train/y_train.txt", header=FALSE)
subject_train <- read.table("train/subject_train.txt", header=FALSE)
features <- read.table("features.txt", header=FALSE)
activity_labels <- read.table("activity_labels.txt", header=FALSE)

#Merge the training and test data sets
x_combined <- rbind(x_train, x_test)
y_combined <- rbind(y_train, y_test)
subject_combined <- rbind(subject_train, subject_test)

#Remove unmerged data frames
rm(subject_test, subject_train, x_test, x_train, y_test, y_train)

#Assign variable names to combined data
names(x_combined) <- features$V2
names(y_combined) <- "activity_label"
names(subject_combined) <- "subject"
names(activity_labels) <- c("activity_label", "activity")

#Further merging and arranging
xy_combined <- cbind(y_combined, x_combined)
sxy_combined <- cbind(subject_combined, xy_combined)
ID <- c(1:10299)
id_combined <- cbind(ID, sxy_combined)
all_combined <- merge(activity_labels, id_combined, by = "activity_label")
all_combined <- arrange(all_combined, ID)
all_combined <- select(all_combined, ID, subject, activity_label, activity, 5:565)

#Select mean and standard deviation
selection <- select(all_combined, activity, subject,
                    grep("mean()", names(all_combined)), 
                    grep("std()", names(all_combined)))

#Create data set with mean of each variable for each activity and each subject
activity_data <- selection %>% group_by(activity, subject) %>% summarise_each(funs(mean))

#Gather data into long data frame
activity_gathered <- gather(activity_data, v1, v2, -activity, -subject)

#Separate into component variables
activity_separate <- separate(activity_gathered, v1, c("sensor", "statistic", "axis")) %>%
  separate(sensor, c("domain", "sensor"), sep = 1) %>%
  separate(sensor, c("acceleration signal", "sensor"), sep=4)

#Rename values and make lower case
activity_separate$domain <- gsub("t", "time", activity_separate$domain)
activity_separate$domain <- gsub("f", "frequency", activity_separate$domain)
activity_separate$`acceleration signal` <- gsub("Grav", "Gravity", activity_separate$`acceleration signal`)
activity_separate$`acceleration signal` <- tolower(activity_separate$`acceleration signal`)
activity_separate$sensor <- gsub("ity", "", activity_separate$sensor)
activity_separate$sensor <- gsub("Body", "", activity_separate$sensor)

#Make copies of remaining compound variable (separate() could not handle this)
activity_mutate <- mutate(activity_separate, sensor2 = sensor, sensor3 = sensor) %>%
  select(1:5, 9, 10, 6:8)

#Rename values of copied columns
activity_mutate$sensor <- gsub("Jerk", "", activity_mutate$sensor)
activity_mutate$sensor <- gsub("Mag", "", activity_mutate$sensor)
activity_mutate$sensor2 <- gsub("Acc", "", activity_mutate$sensor2)
activity_mutate$sensor2 <- gsub("Gyro", "", activity_mutate$sensor2)
activity_mutate$sensor2 <- gsub("Mag", "", activity_mutate$sensor2)
activity_mutate$sensor3 <- gsub("Acc", "", activity_mutate$sensor3)
activity_mutate$sensor3 <- gsub("Jerk", "", activity_mutate$sensor3)
activity_mutate$sensor3 <- gsub("Gyro", "", activity_mutate$sensor3)
activity_mutate$sensor <- tolower(activity_mutate$sensor)
activity_mutate$sensor2 <- tolower(activity_mutate$sensor2)
activity_mutate$sensor3 <- tolower(activity_mutate$sensor3)
activity_mutate$activity <- tolower(activity_mutate$activity)

#Rename variable names
activity_mutate <- activity_mutate %>% rename("jerk signal" = sensor2) %>% rename(magnitude = sensor3)

#Remove "meanFreq"
activity_filtered <- filter(activity_mutate, statistic != "meanFreq")

#Spread mean and std values across two variables
tidy_data <- spread(activity_filtered, statistic, v2)

#Convert from character to factor variables
tidy_data$activity <- as.factor(tidy_data$activity)
tidy_data$domain <- as.factor(tidy_data$domain)
tidy_data$`acceleration signal` <- as.factor(tidy_data$`acceleration signal`)
tidy_data$sensor <- as.factor(tidy_data$sensor)
tidy_data$`jerk signal` <- as.factor(tidy_data$`jerk signal`)
tidy_data$magnitude <- as.factor(tidy_data$magnitude)
tidy_data$axis <- as.factor(tidy_data$axis)

#Insert NA values
levels(tidy_data$`jerk signal`) <- c(NA, "jerk")
levels(tidy_data$magnitude) <- c(NA, "magnitude")
levels(tidy_data$axis) <- c(NA, "X", "Y", "Z")

#Write the table "tidy_data.txt"
setwd("/Users/ashleysharp/Dropbox/R/Coursera/gettingcleaning/")
write.table(tidy_data, "tidy_data.txt", col.names = TRUE)
