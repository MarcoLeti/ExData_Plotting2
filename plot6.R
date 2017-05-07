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

# Read the file NEI containing emissions data
NEI <- readRDS("summarySCC_PM25.rds")

# Read the file SCC containing the source code classification
SCC <- readRDS("Source_Classification_Code.rds")

# Find in the SCC file the words "Coal" and "Comb" from the column "EI.Sector"
subs <- grepl("Vehicles", SCC$EI.Sector)

# Subset the SCC file based on the above
SCC.subs <- SCC[subs, ]

# Merge the NEI file and SCC subsetted, this will filter also the NEI file based on the subsetted one
NEISCC.merged <- merge(NEI, SCC.subs)

# Filter data per Baltimore City, Maryland (fips == "24510")
Balt.NEISCC.Filtered.Merged <- filter(NEISCC.merged, fips == "24510")

# Filter data per Los Angeles County, California (fips == "06037")
LosAng.NEISCC.Filtered.Merged <- filter(NEISCC.merged, fips == "06037")

# Aggregate data before plotting
Baltimore <- aggregate(x = list(PM25.Emissions = Balt.NEISCC.Filtered.Merged$Emissions), 
                    by = list(Year = Balt.NEISCC.Filtered.Merged$year), 
                    FUN = sum)

LosAngeles <- aggregate(x = list(PM25.Emissions = LosAng.NEISCC.Filtered.Merged$Emissions), 
                         by = list(Year = LosAng.NEISCC.Filtered.Merged$year), 
                         FUN = sum)

# Calculate the rate of change between years
Balt.rate <- 100*diff(Baltimore$PM25.Emissions)/Baltimore[-nrow(Baltimore),]$PM25.Emissions

LosAng.rate <- 100*diff(LosAngeles$PM25.Emissions)/LosAngeles[-nrow(LosAngeles),]$PM25.Emissions

# Create the new x-axis (the first year will not appear anymore as we are plotting rate of changes)
Years <- c("(2002-1999)/1999", "(2005-2002)/2002", "(2008-2005)/2005")

# Create the bar plot
png(filename="plot6.png", width = 480, height = 480)
barplot(Balt.rate, 
        names.arg = Years, 
        col=rgb(0,0,1,1/4), 
        ylim=c(-62,10),
        xlab = "Year",
        ylab = "PM25 Emission (in %)",
        main = "Rate of change PM25 emissions from motor vehicle")

barplot(LosAng.rate, 
        names.arg = Years, 
        col=rgb(1,0,0,1/4), 
        ylim=c(-62,10), 
        add = T)

legend("bottomright", 
       legend = c("Baltimore","Los Angeles"), 
       col = c(rgb(0,0,1,1/4), rgb(1,0,0,1/4)), 
       pch = 19)

dev.off()