# GettingAndCleaningDataProject
Files for final project

This file documents the process to complete the project as assigned

# Script Description

The script "run_analysis.R" contains 4 functions:

1. MergeFiles(): This function merges the data from the test and train directories in the original data.
The function assumes that the script is located in the directory that contains the original data,
It creates a directory name "MFiles", and the subdirectory "Mfiles\Inertial Signals". The outcome of this
program is a set of 9 files with the prefix "Merged_" that contain the total number of observations (N=10299)
for each of the variables "total_acc_x", "total_acc_y",... "body_gyro_z" as described in the original data.
In addition this function creates three files in the "MFiles" directory:"Merged_subject.txt", "Merged_X.txt", and
"Merged_y.txt" that contain the combined information of a) Subject performning the activity, b) Combined data set, 
and c) datalabels.

2. Summary_file(): This functions uses the combined files created by the function MergeFiles() to extract only
the mean and standard deviation of the data contained in the "MFiles\Inertial Signals" directory. The
outcome of this function is the file "Merged_Summary.txt"

3. Tidy_Data (): This function uses the file "Merged_Summary.txt" to create a file that contains the average of
each observation organizez by subject and activity.  The file created is named "TidyFile.txt"

4.TidyData(): This a short function that runs the previous functions in sequence to obtain the file "TidyFile.txt"

# Procedure

1. run R.
2. Make sure the "run_analysis.R" script is located in the same directory that contains the original data
3. source("run_analysis.R")
4. Run Tidy_Data(). A series of messages will appear indicating the steps in the process. When done you will be
able to use R to open the file "./MFiles/TidyFile.txt" and check the summarized data.
