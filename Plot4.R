# Coursera Data Science Specialization
# Exploratory Data
# Darrell Gerber
# February 21, 2021
#
# Week 1: Project
# Plot 4
#
# Description: Load in the project zip file and extract the data set. Merge
#   and change the class of the date and time. Subset to only use the data
#   for 2007-02-01 and 2007-02-02. Reproduce Plot 4 in README.md. This
#   plot is a 2 x 2 set of plots. The upper left is the same plot used in 
#   Plot 2. The upper right is a plot of Voltage by time. The lower left 
#   plot is the same as Plot 3 with a slight change to remove the border
#   around the legend. The lower right plot is the Global Reactive Power
#   vs time. 

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
png(filename = "Plot4.png")
par(mfrow = c(2,2))
# Top left graph
with(workingData, plot(DateTime, Global_active_power, type = "l",
                       ylab = "Global Active Power (kilowatts)",
                       xlab = ""))
# Top right graph
with(workingData, plot(DateTime, Voltage, type = "l",
                       ylab = "Voltage",
                       xlab = "datetime"))
# Bottom left graph
with(workingData, plot(DateTime, Sub_metering_1, col = "black", type = "l",
                       ylab = "Energy sub metering",
                       xlab = ""))
with(workingData, points(DateTime, Sub_metering_2, col = "red", type = "l"))
with(workingData, points(DateTime, Sub_metering_3, col = "blue", type = "l"))
legend("topright", lty = 1, pch = NA, bty = "n", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# Top right graph
with(workingData, plot(DateTime, Global_reactive_power, type = "l",
                       ylab = "Global_reactive_power",
                       xlab = "datetime"))
dev.off()
