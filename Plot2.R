# Coursera Data Science Specialization
# Exploratory Data
# Darrell Gerber
# February 21, 2021
#
# Week 1: Project
# Plot 2
#
# Description: Load in the project zip file and extract the data set. Merge
#   and change the class of the date and time. Subset to only use the data
#   for 2007-02-01 and 2007-02-02. Reproduce Plot 2 in README.md. This
#   plot is a simple line plot of the Global Active Power by time.

library(dplyr)

## Download and unzip the zip file from the course website
#     NOTE: checks to see if this was already done and skips if yes
destFolder = "./data"
if(!file.exists(destFolder)) {dir.create(destFolder)}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destFile = "./data/household_power_consumption.zip"
if(!file.exists(destFile)) {
  download.file(fileUrl, destfile = destFile, method = "curl")
  
  unzip(destFile, exdir = destFolder, overwrite = TRUE)
}

##  Load the data file
dataFile <- paste(destFolder, "/", unzip(destFile, list = TRUE)$Name, sep = "")
rawData <- read.table(dataFile, sep = ";", header = TRUE, 
                      quote = "", na.strings = "?")
# Merge and change type of the date/time
dateTime <- strptime(paste(rawData$Date, rawData$Time), 
                     format = "%d/%m/%Y %H:%M:%S")
rawData <- mutate(rawData, DateTime = dateTime)

# Subset only the dates we will use
workingData <- subset(rawData, (rawData$DateTime >= as.POSIXct("2007-02-01 00:00:00"))
                      & (rawData$DateTime <= as.POSIXct("2007-02-02 23:59:59")))

# Add in day of the week
# Draw the graph
png(filename = "Plot2.png")
with(workingData, plot(DateTime, Global_active_power, type = "l",
                       ylab = "Global Active Power (kilowatts)",
                       xlab = ""))
dev.off()
