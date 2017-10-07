## Employment information
## Private Firms, Establishments, Employment, Annual Payroll and Receipts by Firm Size based on number of employees, 1988-2014
## Source: U.S. Small Business Administration

## Load required lirbaries.
library(knitr)
library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(DT)
library(zoo)

## Load raw data file into R Studio
employment_raw <- read.csv("~/Desktop/employmentraw.csv", header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
employment_raw[1:10,1:5]

## Eliminate rows without data
employment_data <- employment_raw[rowSums(is.na(employment_raw)) == 0,]
datatable(employment_data)

## Fill in empty values in the column Item with row above
employment_fill <- employment_data
employment_fill$Item[employment_fill$Item == ""] <- NA
employment_fill$Item <- na.locf(employment_fill$Item)
datatable(employment_fill)

## Subset data to just look at one year
employment_2012 <- employment_fill[employment_fill$Year == 2012,]
datatable(employment_2012)



