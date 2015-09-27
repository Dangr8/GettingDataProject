The script run_analysis.R is designed to take several text files (X_test.txt, y_test.txt, subject_test.txt, X_train.txt, y_train.txt, subject_train.txt, and features.txt) from the UCI HAR dataset and combine them into a tidy data set with mean summarized variables.

1. The files are imported using read.table
2. The column names that will be taken from the rows of features.txt are cleaned to remove special characters '(' and ')' and make the names more descriptive
3. The column names on the test and train data are replaced
4. Subject and activity data are appended to the front of the test and train data using cbind at the same time that we rename the column titles to avoid duplicates
5. Combine the test and train data using rbind
6. Remove duplicate column headers since these columns are not part of the final tidy data set and will cause errors if preserved past this point
7. Subset columns with 'mean' and 'std' in the names to match project requirements
8. Replace activity numerical ID with actual text name
9. Group by subject_id then by activity to show each activity that each subject did then summarize each variable within those groups to obtain the mean value so we end up with each subject having six activities
10. write.table to generate the summary.txt data set for sharing