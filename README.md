# Introduction

This repository contains the files necessary to conduct an data analysis for the course Getting and Cleaning data from Coursera.

The project consists of getting and cleaning the data from the UCI Machine Learning Repository. 
The data set contains records of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.



It contains 3 files : 

* Codebook.md, which describes the variables, the data, and all transformations that have been performed to clean the data
* README.md, describes the project and how the files work together
* run_analysis.R, contains the script that performs the data analysis

The original data set comes from the UCI Machine Learning Repository and can be found on the following link : 
[Raw data source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The description of the original data can be found here : 
[Description raw data source](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 


# Instructions

## Steps
1. Clone this repository on your computer
2. Run the script run_analysis.R

## Output

**The script will execute all the necessary steps to conduct the data analysis and will produce a cleaned data set called** *FinalTidySet_CourseProject.txt*
**which contains the mean of both, mean() and std() -standard deviation- variables of the raws files, for each activity and each subject**

# Requirements

* You will need the R environment installed on your local computer in order to run the scripts.
* The R package "plyr" needs to be installed *if installed, the script will load it automatically*

## Notes

This analysis has been tested on a 15-inch Macbook Pro Retina running under OS X 10.9.3

The R environment was as displayed : 

```
> version                       
platform       x86_64-apple-darwin13.1.0   
arch           x86_64                      
os             darwin13.1.0                
system         x86_64, darwin13.1.0        
status                                     
major          3                           
minor          1.0                         
year           2014                        
month          04                          
day            10                          
svn rev        65387                       
language       R                           
version.string R version 3.1.0 (2014-04-10)
nickname       Spring Dance 
```