renv::init()


#-------------------------------------------------------------------------------------
### Description
#-------------------------------------------------------------------------------------



#-------------------------------------------------------------------------------------
#### Set Up 
#-------------------------------------------------------------------------------------

#Install Packages that may be needed
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

#view  and read data into raw data file path
view(ntl_icecover)
write_csv(ntl_icecover, "./00_rawdata/icedata.csv")


