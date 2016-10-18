# Getting and Cleaning Data Course Project

This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

1. Read the data into R
2. Merge the training and test data sets
3. Assign variable names
4. Select mean and standard deviation variables
5. Create new data frame with mean of each variable for each activity and each subject
6. Tidy data frame by gathering data then separating into one variable per column (e.g. tBodyAcc-XYZ -> domain (time), acceleration signal (body), sensor (acc), axis (XYZ))
7. Write data frame to file "tidy_data.txt"