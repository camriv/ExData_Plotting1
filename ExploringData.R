## Data: Individual household electric power consumption Data Set
## Source: UC Irvine Machine Learning Repository
## Dimensions: 2,075,259 rows and 9 columns
## Required data: data from the dates 2007-02-01 and 2007-02-02
## Missing values: "?"


## Download and unzip project files
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
tmpfile <- tempfile(pattern = "household power consumption",
        tmpdir = tempdir(), fileext = ".zip")
download.file(url, tmpfile)
power <- unzip(tmpfile, junkpaths = TRUE)

## Read first few lines of the table
sample <- read.table(power, nrows = 5, na.strings = "?")
## Find out that sep = ";" thus read.csv2 is a better choice
sample <- read.csv2(power, nrows = 5,
        stringsAsFactors = FALSE, na.strings = "?")
## Find out that Date is in format %d/%m/%Y

## Estimate object size based on 1 byte/character, 2^20 bytes/MB
sum(nchar(sample[1,]))    ## 57 characters per row
round(57 * 2075259* 1 / 2^20, 0)  ## 113 MB
## Object size is tolerable

## Read data and determine actual object size
full.data <- read.csv2(power, stringsAsFactors = FALSE, na.strings = "?")
print(object.size(full.data), units = "Mb")    ## 143 MB

## Data size is maangeable, otherwise, automatic selection of required dates can be done by sqldf::read.csv2.sql

## Additional notes:
## With stringsAsFactors = FALSE,
##      read.csv2.sql reads columns as either character or numeric
##      read.csv2 where all columns are read as character


## Option 1: use utils::read.csv2
full.data <- read.csv2(power, stringsAsFactors = FALSE, na.strings = "?")
data <- subset(full.data,
        subset = with(full.data, Date == "1/2/2007" | Date == "2/2/2007"))
## All classes are read as character
## colClassess cannot be directly used to read Date and Time as Date and POSIXct since they are not in the default strp format
## Convert character dates and time to POSIXct (strptime gives POSIXlt)
data$Time <- with(data, as.POSIXct(paste(Date, Time),
        format="%d/%m/%Y %H:%M:%S"))
## Convert columns 3:9 to numeric
data[3:9] <- sapply(data[3:9], as.numeric)


## Option 2: use sqldf::read.csv2.sql
library(sqldf)
data <- read.csv2.sql(file = power,
        sql = "SELECT * FROM file WHERE Date IN ('1/2/2007', '2/2/2007')",
        stringsAsFactors = FALSE, na.strings = "?")
closeAllConnections()
## First 2 columns are read as character, rest are read as numeric
## Convert character dates and time to POSIXct (strptime gives POSIXlt)
data$Time <- with(data, as.POSIXct(paste(Date, Time),
        format="%d/%m/%Y %H:%M:%S"))


## Export processed data
write.table(data, file = "./tidy_household_power_consumption.txt",
            sep = ";", row.names = FALSE)