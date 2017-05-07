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
                    by = list(Year = NEI.Filtered$year, Type = NEI.Filtered$type),
                    FUN = sum)

# Check if the package ggplot2 is installed, in negative case, install it.
if (!"ggplot2" %in% installed.packages()) {
        warning("Installing ggplot2 package.")
        install.packages("ggplot2")
}

library(ggplot2)

# Create the bar plot
png(filename="plot3.png", width = 480, height = 480)
g <- ggplot(myData, aes(x = factor(Year), y = PM25.Emissions))
g + geom_bar(stat="identity") + 
        facet_grid(. ~ Type) +
        labs(x = "Year") + 
        labs(y = expression("Total " * PM[2.5] * " Emissions"))+
        labs(title = expression(PM[2.5] * " Emissions by type of source in Baltimore City"))
dev.off()
