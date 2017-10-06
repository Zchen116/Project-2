## EIA Energy Information on Renewable Energy Consumption by Source, January 2013 to August 2017
## Units of raw data are quadrillion BTU

## Load required lirbaries.
library(knitr)
library(stringr)
library(tibble)
library(ggplot2)
library(DT)

## Load raw data file into R Studio, scanning the first two rows to combine the two row header into one column name
renewable_raw <- read.csv("~/Desktop/renewableraw.csv", skip = 2, header = FALSE)
header_rows <- read.csv("~/Desktop/renewableraw.csv", nrows=2, header=FALSE)
new_header <- sapply(header_rows, paste, collapse="_")
names(renewable_raw) <- new_header
renewable_raw[1:10,1:3]

## Create a datasubset with only the Residential Consumption of Renewable Energy rows 24 through 27, all months and years
## Replace the first row of the new table with the first row of the raw table to retain the months designation
renewable_raw[,1]
renewable_res <- renewable_raw[24:27,]
datatable(renewable_res)

## Build vectors from the raw data so it will be easier to manipulate
## Convert the units because Quadrillion BTU ("Quads") is not commonly used, instead use Giga-Watthours ("GWh")
## Conversion factor: 1 Quad = 293,071.07 GWh
## Round the numbers for ease of viewing
Time <- c(new_header)
Geothermal_GWh <- round(mapply(`*`, as.numeric(c(renewable_res[1,])), 293071.07), digits = 1)
Solar_GWh <- round(mapply(`*`, as.numeric(c(renewable_res[2,])), 293071.07), digits = 1)
Biomass_GWh <- round(mapply(`*`, as.numeric(c(renewable_res[3,])) , 293071.07), digits = 1)
Total_GWh <- round(mapply(`*`, as.numeric(c(renewable_res[4,])), 293071.07), digits = 1)

## Create a dataframe from the original data making the rows vectors
renewable_res_GWh <- data.frame(Time, Geothermal_GWh, Solar_GWh, Biomass_GWh, Total_GWh)
datatable(renewable_res_GWh)

## Remove the first row because this is not valid information as part of the datasubset
renewable_res_GWh <- renewable_res_GWh[-1,]
datatable(renewable_res_GWh)

## Plot the data to visualize the change in renewable energy consumption in the residential sector and to determine if one technology is contributing more than others to thte overall trends
## Plot the total renewable energy consumed in the residential sector using blue
ggplot(data=renewable_res_GWh, aes(x=Time, y=Total_GWh, group=1)) +
  geom_line(color="#0066ff", size=1) +
  geom_point(color="#0066ff", size=2) +
  scale_x_discrete(breaks=c("2013","2014","2015","2016","2017")) +
  ggtitle("Monthly Consumption of Total Renewable Energy in GWh for Residential Sector") +
  labs(x="January 2013 through August 2017", y="Consumption in GWh") +
  theme(axis.title.y = element_text(size=12, color="#666666")) +
  theme(axis.text = element_text(size=12, family="Trebuchet MS")) +
  theme(plot.title = element_text(size=12, family="Trebuchet MS", face="bold", hjust=0, color="#666666"))

## Plot the solar component of the renewable energy consumed in the residential sector using red
ggplot(data=renewable_res_GWh, aes(x=Time, y=Solar_GWh, group=1)) +
  geom_line(color="#aa0022", size=1) +
  geom_point(color="#aa0022", size=2) +
  scale_x_discrete(breaks=c("2013","2014","2015","2016","2017")) +
  ggtitle("Monthly Consumption of Solar Energy in GWh for Residential Sector") +
  labs(x="January 2013 through August 2017", y="Consumption in GWh") +
  theme(axis.title.y = element_text(size=12, color="#666666")) +
  theme(axis.text = element_text(size=12, family="Trebuchet MS")) +
  theme(plot.title = element_text(size=12, family="Trebuchet MS", face="bold", hjust=0, color="#666666"))

  