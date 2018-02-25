## Download and unzip project files
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
tmpfile <- tempfile(pattern = "household power consumption",
        tmpdir = tempdir(), fileext = ".zip")
download.file(url, tmpfile)
power <- unzip(tmpfile, junkpaths = TRUE)

## Based on "ExploringData.R" script, data size is manageable
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


## Set global plot settings
par(mar = c(5, 5, 1, 1)+0.1, bg = "transparent")

## Create Global Active Power plot
with(data, plot(Time, Global_active_power, type="l",
        xlab="Time", ylab="Global Active Power (kW)")) 

## Export to png file device
dev.copy(png, file = "plot2.png")
dev.off()