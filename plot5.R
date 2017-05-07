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
NEISCC.Filtered.Merged <- filter(NEISCC.merged, fips == "24510")

# Aggregate data before plotting
myData <- aggregate(x = list(PM25.Emissions = NEISCC.Filtered.Merged$Emissions), 
                    by = list(Year = NEISCC.Filtered.Merged$year), 
                    FUN = sum)

# Create the bar plot
png(filename="plot5.png", width = 480, height = 480)
barplot(myData$PM25.Emissions, 
        names.arg = myData$Year,
        xlab = "Year",
        ylab = "Total PM25 Emission",
        main = "PM25 emissions from motor vehicle Baltimore City")
dev.off()