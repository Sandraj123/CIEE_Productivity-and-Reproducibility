#Author: Sandra Jaskowiak

#-------------------------------------------------------------------------------------
### Description
#-------------------------------------------------------------------------------------

#This script is used to demonstrate my understanding of productivity and reproducibility methods for my course "mini-project". This script includes the use of renv to create a project-local package library. It also includes a line of code to read obtained data in to a "raw data" project folder, and lines of code to save created figures into a "figures" project folder. THere are three components to the script: the set up, part 1 checking/cleaning data, and part 2 creating figures for a manuscript. 

#code used to great plots in part 2 was obtained from https://lter.github.io/lterdatasampler/articles/ntl_icecover_vignette.html

#-------------------------------------------------------------------------------------
#### Set Up 
#-------------------------------------------------------------------------------------

##Install Packages that may be needed
install.packages("lterdatasampler")
install.packages("tidyverse")
install.packages("assertr")
install.packages("stringdist")
install.packages("GGally")
install.packages("prereg")

library(lterdatasampler)
library(tidyverse)
library(assertr)
library(stringdist)
library(GGally)

#generate a project-local R library to save the versions of packages used in this script. 
renv::init()
#Check the status of installed packages
renv::status()

##Set working directory. Change as needed depending on your directory path.
setwd("~/Simon Fraser University/Classes/Productivity and Reproducibility in Ecology and Evolution/CIEE_Productivity-and-Reproducibility")

##write data into raw data file path
write_csv(ntl_icecover, "./00_rawdata/icedata.csv")

## Import raw data file and view
icedata <- read_csv("00_rawdata/icedata.csv")
view(icedata)


#-------------------------------------------------------------------------------------
### Part 1. Exlore the data, Check for errors to clean
#-------------------------------------------------------------------------------------

##Explore the data
dim(icedata) # 334 rows and 5 columns- Verify that the number of rows reflects number of observations in your metadata
head(icedata, 10) # view first 10 rows of data
str(icedata) # check the structure
summary(icedata) # summarize the data set

sum(!is.na(icedata$lakeid)) # 334 entries for lakeid meaning that no rows are missing a lake name
table(icedata$lakeid) # check to see how many lakes are included in this data set and if any spelling errors. No spelling errors identified in the character field

##Determine the number of observations in ice-on
icedata %>%
  summarise(
    n_non_na = sum(!is.na(ice_on)), 
    n_na     = sum(is.na(ice_on))   
  ) #Total of 334 observations (333 non-NA values and 1 NA values). This matches our data frame dimensions as previously confirmed.

##Determine the number of observations in ice-off
icedata %>%
  summarise(
    n_non_na = sum(!is.na(ice_off)), 
    n_na     = sum(is.na(ice_off))   
  ) #Total of 334 observations (332 non-NA values and 2 NA values). This matches our data frame dimensions as previously confirmed.

##Determine the number of observations in ice_duration
icedata %>%
  summarise(
    n_non_na = sum(!is.na(ice_duration)), 
    n_na     = sum(is.na(ice_duration))   
  ) #Total of 334 observations (331 non-NA values and 3 NA values). This matches our data frame dimensions as previously confirmed.

##Determine the number of observations in year
icedata %>%
  summarise(
    n_non_na = sum(!is.na(year)), 
    n_na     = sum(is.na(year))   
  ) #Total of 334 observations (334 non-NA values and 0 NA values). This matches our data frame dimensions as previously confirmed.

##Create histogram to visually see the data in ice_duration and assess for outliers
hist(icedata$ice_duration, nclass = 30) # no impossible values below 0 or above 365 detected

## it appears dataset is clean and not cleaning procedures are required

#-------------------------------------------------------------------------------------
### Part 2. Compare and create figures fpr ice duration data between two lakes
#-------------------------------------------------------------------------------------

## create boxplot to compare ice duration between the two lakes (Lake Mendota and Lake Monona)
lake_ice <-
  ggplot(data = icedata %>% filter(!is.na(ice_duration)), aes(x = lakeid, y = ice_duration)) +
  geom_boxplot(aes(color = lakeid, shape = lakeid),
               alpha = 0.8,
               width = 0.5) +
  theme_minimal() +
  labs(
    title = "Ice Duration of Lakes in the Madison, WI Area",
    y = "Ice Duration (Days)",
    x = "Lake",
    subtitle = "North Temperate Lakes LTER"
  ) +
  geom_jitter(
    aes(color = lakeid),
    alpha = 0.5,
    show.legend = FALSE,
    position = position_jitter(width = 0.2, seed = 0)
  )

lake_ice

#save thsi figure to figures folder
ggsave(filename = "03_figures/ice_duration_average.png", plot = lake_ice, width = 6, height = 4, units = "in")

# Create plot to observe the trend in ice duration in each lake through time
duration <-
  ggplot(data = icedata, aes(x = year)) +
  geom_line(aes(y = ice_duration, color = lakeid), alpha = 0.7) +
  theme_minimal() +
  labs(x = "Year", y = "Ice Duration (Days)", title = "Ice Duration of Lakes in the Madison, WI Area", subtitle = "North Temperate Lakes LTER")

duration

#save this figure to figures folder
ggsave(filename = "03_figures/ice_duration_trend.png", plot = duration, width = 6, height = 4, units = "in")

## run a t-test to compare average ice duration between the lakes
t.test(ice_duration ~ lakeid, data = icedata)

#Create a txt file to hold console output for the t-test within the outdata project folder. Chaneg output folder directory as needed
output_folder <- "./02_outdata/" 
ttest_ouput <- "ttest_output.txt"

full_path <- paste0(output_folder, ttest_ouput)

#run the following line to direct all following output into the created .txt file
sink(file = full_path) 

#run the t-test again so that output will sync to the .txt file. 
t.test(ice_duration ~ lakeid, data = icedata)

sink() #end output sync. All lines run after this will no longer go to the .txt file in the outdata folder.

