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

library(lterdatasampler)
library(tidyverse)
library(assertr)
library(stringdist)
library(GGally)

#voew and save raw data

view(ntl_icecover)
