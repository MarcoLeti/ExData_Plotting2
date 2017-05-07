#-----------------------------------------------#
# Author: Marco Letico                          #
# Data Science specialization by Coursera       #
# Exploratory Data Analysis Week 4              #
#-----------------------------------------------#


# Create the directory, download the file and unzip it
if(!exists("myDir")){dir.create("myDir")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "./myDir/myZip.zip")
setwd("./myDir")
unzip(zipfile = "myZip.zip")

# Read the file containing data
NEI <- readRDS("summarySCC_PM25.rds")

# Aggregate data before plotting
myData <- aggregate(x = list(PM25.Emissions = NEI$Emissions),
                    by = list(Year = NEI$year),
                    FUN = sum)

# Create the bar plot
png(filename="plot1.png", width = 480, height = 480)
barplot(myData$PM25.Emissions,
        names.arg = myData$Year,
        xlab = "Year",
        ylab = "Total PM25 Emission",
        main = "PM25 emissions in the United States")
dev.off()