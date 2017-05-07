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

# Check if the package dplyr is installed, in negative case, install it.
if (!"dplyr" %in% installed.packages()) {
        warning("Installing dplyr package.")
        install.packages("dplyr")
}

library(dplyr)

# Read the file containing data
NEI <- readRDS("summarySCC_PM25.rds")

# Filter data per Baltimore City, Maryland (fips == "24510")
NEI.Filtered <- filter(NEI, fips == "24510")

# Aggregate data before plotting
myData <- aggregate(x = list(PM25.Emissions = NEI.Filtered$Emissions),
                    by = list(Year = NEI.Filtered$year),
                    FUN = sum)

# Create the bar plot
png(filename="plot2.png", width = 480, height = 480)
barplot(myData$PM25.Emissions,
        names.arg = myData$Year,
        xlab = "Year",
        ylab = "Total PM25 Emission",
        main = "PM25 emissions in Baltimore City, Maryland")
dev.off()