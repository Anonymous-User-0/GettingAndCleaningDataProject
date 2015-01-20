MergeFiles<- function( ){
## This file merges the Test and Train data
## It creates in the current directory a directory call "MFiles" that 
## contain files with the same structure of the
## original files with a "Merged_" in front of the name
## The following commands create 3 vector that will be used to create automatically
## the names of the files to be Mergea
DirNames<-c("train","test")
Coord<-c("x","y","z")
NameFiles<-c("total_acc","body_acc","body_gyro")
## Checking for existence of needed directories
if (!file.exists("MFiles")){ 
	dir.create("MFiles")
}
if (!file.exists("MFiles/Inertial Signals")){ 
	dir.create("MFiles/Inertial Signals")
}
## Files are accessed here, names are created automatically and the loops run through all possibilities
for (Ci in Coord){
	for (Ni in NameFiles){
		FTrain<-paste("./train/Inertial Signals/",Ni,"_",Ci,"_train.txt",sep="")
		FTest<-paste("./test/Inertial Signals/",Ni,"_",Ci,"_test.txt",sep="")
		TrainFile<-read.table(FTrain)
		TestFile<-read.table(FTest)
		DF1<-tbl_df(TrainFile)
		DF2<-tbl_df(TestFile)
		rm(TrainFile)
		rm(TestFile)
       	## Create a new column with type of data information ("Train" or "Test" in case is needed later)
		DF1<-mutate(DF1,DataType="Train")
		DF2<-mutate(DF2,DataType="Test")
		MFile<-paste("./MFiles/Inertial Signals/Merged_",Ni,"_",Ci,".txt",sep="")
		Mess<-paste("Writing file: ",MFile)
		print(Mess)
		write.table(rbind(DF1,DF2),MFile)
		}
	}
OtherFiles<-c("subject","X","y")
for (Ci in OtherFiles){
	FTrain<-paste("./train/",Ci,"_train.txt",sep="")
	FTest<-paste("./test/",Ci,"_test.txt",sep="")
	MFile<-paste("./MFiles/Merged_",Ci,".txt",sep="")
	TrainFile<-read.table(FTrain)
	TestFile<-read.table(FTest)
	DF1<-tbl_df(TrainFile)
	DF2<-tbl_df(TestFile)
	rm(TrainFile)
	rm(TestFile)
	## Create a new column with type of data information (for future use)
	DF1<-mutate(DF1,DataType="Train")
	DF2<-mutate(DF2,DataType="Test")
	Mess<-paste("Writing file: ",MFile)
	print(Mess)
	write.table(rbind(DF1,DF2),MFile)
	}
}


Summary_File<-function( ){
## This function extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive names to name the columns in the data set
Coord<-c("x","y","z")
NameFiles<-c("total_acc","body_acc","body_gyro")
DF1<-read.table("./MFiles/Merged_subject.txt")
DF2<-read.table("./MFiles/Merged_y.txt")
colnames(DF1)<-c("No.Subject","DataType")
colnames(DF2)<-c("Activity","DataType")
JoinFile<-tbl_df(cbind(DF1,select(DF2,Activity)))
JoinFile<-select(JoinFile,DataType,No.Subject,Activity)
NameFiles<-c("total_acc","body_acc","body_gyro")
for (Ci in Coord){
	for (Ni in NameFiles){
		MFile<-paste("./MFiles/Inertial Signals/Merged_",Ni,"_",Ci,".txt",sep="")
		Mess<-paste("Reading and preparing: ",MFile)
		print(Mess)
		DF3<-read.table(MFile)
		DDF3<-tbl_df(DF3)
		rm(MFile)
		MeanFile<-rowMeans(select(DDF3,V1:V128))
		sdFile<-apply(select(DDF3,V1:V128),1,sd)
		JoinFile<-tbl_df(cbind(JoinFile,MeanFile,sdFile))
		colnames(JoinFile)[colnames(JoinFile)=="MeanFile"] <- paste("Mean.",Ni,".",Ci,sep="")
		colnames(JoinFile)[colnames(JoinFile)=="sdFile"] <- paste("Std.",Ni,".",Ci,sep="")
		}
	}
MFile<-paste("./MFiles/Merged_Summary.txt",sep="")
write.table(JoinFile,MFile)
}


Tidy_Data<-function( ){
## This function prepares the a tidy file from the file "./MFiles/Merged_Summary.txt"
## created by the function Summary_File(),the average of each variable for each activity and each subject
MFile<-read.table("./MFiles/Merged_Summary.txt")
DDF<-tbl_df(MFile)
rm(MFile)
by_Subj<-group_by(DDF,No.Subject,Activity)
TidyFile <-summarize(by_Subj,Mean.total_acc.x=mean(Mean.total_acc.x), Mean.body_acc.x=mean(Mean.body_acc.x), Mean.body_gyro.x=mean(Mean.body_gyro.x),
Mean.total_acc.y=mean(Mean.total_acc.y), Mean.body_acc.y=mean(Mean.body_acc.y), Mean.body_gyro.y=mean(Mean.body_gyro.y),
Mean.total_acc.z=mean(Mean.total_acc.z), Mean.body_acc.z=mean(Mean.body_acc.z), Mean.body_gyro.z=mean(Mean.body_gyro.z))
MFile<-read.table("activity_labels.txt")
XTable<-MFile[,2]
### Changing the activity number to something meaningful
TidyFile<-mutate(TidyFile,Activity=XTable[Activity])
write.table(TidyFile,"./MFiles/TidyFile.txt",row.name=FALSE)
TidyFile
}

TidyData <- function ( ){
## This script controls the order in which the data is prepared
library(dplyr)
Mess<-paste("==================================")
print(Mess)
Mess<-paste("Merging data files, please wait...")
print(Mess)
Mess<-paste("==================================")
print(Mess)
	MergeFiles()
Mess<-paste("==================================")
print(Mess)
Mess<-paste("Creating summary file, please wait...")
print(Mess)
Mess<-paste("==================================")
print(Mess)
	Summary_File()
Mess<-paste("==================================")
print(Mess)
Mess<-paste("Creating file with tidy data, please wait...")
print(Mess)
Mess<-paste("==================================")
	Tidy_Data()
}

