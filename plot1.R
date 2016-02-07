rm(list=ls())
library(dplyr)

unzip(zipfile = "data/exdata-data-household_power_consumption-2.zip",exdir = "data/")

# get column names from 1st row
colNames <- unlist(strsplit(readLines("data/household_power_consumption.txt",n=1),";"))

# get the rows that feb 1, 2007 and feb 2, 2007 as dates
selectedText <- grep("^[1-2]/2/2007",readLines("data/household_power_consumption.txt"),value=TRUE)

# Read the selected Date
elecData <- read.table(text = selectedText,sep=";", na.strings = "?", col.names=colNames)

electbl <- tbl_df(elecData)

electbl <- electbl[complete.cases(elecData),]

# set rows and columns
par(mfrow=c(1,1))

# plot histogram
hist(electbl$Global_active_power,col = "red",main="Global Active Power",
     xlab="Global Active Power (kilowatts)")

#copy to png
dev.copy(png,file="plot1.png")
dev.off()
