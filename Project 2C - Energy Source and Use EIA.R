## Data: Table C1. Energy Consumption Overview: Estimates by Energy Source and End-Use Sector, 2015 (Trillion Btu)
## US Energy Information Administration

## Load required lirbaries.
library(knitr)
library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(DT)

## Load raw data file into R Studio
energy_all <- read.csv("~/Desktop/EIA-source-use.csv", header = FALSE, stringsAsFactors = FALSE, check.names = FALSE)
energy_all[1:10,]

## This shows the header is across three rows 
## Read the file again without the top two header rows
energy_raw <- read.csv("~/Desktop/EIA-source-use.csv", header = TRUE, skip = 2, stringsAsFactors = FALSE, check.names = FALSE)
energy_raw[1:10,]

## Compare states by looking at the consumption of energy by type
energy_use <- energy_raw[,-2:-10]
energy_use[1:10,]

## Gather and tidy data around the different categories of usage
energy_use_tidy <- gather(energy_use, "Use_Type", "Total_By_Type", Residential:Transportation) %>% 
  arrange(State)
datatable(energy_use_tidy)

## Calculate the total energy consumed for each state by adding every four rows
total_state <- colSums(matrix(energy_use_tidy$Total_By_Type, nrow=4))

## Create a vector with the total value repeated four times to add to the working data set
total_state_4 <- rep(total_state, each = 4)
total_state_4 
energy_use_tidy$Total_All <- total_state_4 
datatable(energy_use_tidy)

## Calculate the percentage contribution for each use type against the total
energy_use_perc <- energy_use_tidy %>%
  mutate(Percent_Total = Total_By_Type / Total_All)

## Round to shorten the Percentage of Total calculation to two digits
energy_use_perc[,"Percent_Total"]=format(round(energy_use_perc[,"Percent_Total"]*100,2),nsmall=2)
datatable(energy_use_perc)

## Various analyses can be performed at this point, such as identifying the state that has the maximum percentage contribution from one of the four sectors 
energy_use_perc$State[which.max(energy_use_perc[,"Percent_Total"])]
energy_use_perc$Use_Type[which.max(energy_use_perc[,"Percent_Total"])]
paste(max(energy_use_perc[,"Percent_Total"]),"%",sep="")

## Similarily looking at which state has the minimum consumption percentage from any one sector
energy_use_perc$State[which.min(energy_use_perc[,"Percent_Total"])]
energy_use_perc$Use_Type[which.min(energy_use_perc[,"Percent_Total"])]
paste(min(energy_use_perc[,"Percent_Total"]),"%",sep="")

## Additionally, we can look at which state has the highest total consumption percentage from any one sector
energy_use_perc$State[which.max(energy_use_perc[,"Total_By_Type"])]
energy_use_perc$Use_Type[which.max(energy_use_perc[,"Total_By_Type"])]
paste(max(energy_use_perc[,"Total_By_Type"]),"%",sep="")
energy_use_perc$Percent_Total[which.max(energy_use_perc[,"Total_By_Type"])]

## Additionally, we can look at which state has the highest total consumption from any one sector
energy_use_perc$State[which.max(energy_use_perc[,"Total_By_Type"])]
energy_use_perc$Use_Type[which.max(energy_use_perc[,"Total_By_Type"])]
paste(max(energy_use_perc[,"Total_By_Type"]),"%",sep="")
