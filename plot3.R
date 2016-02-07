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

# Add Date Time Variable
electbl <- mutate(electbl,datetime = paste(Date,Time))

# Convert the string
electbl$datetime <- strptime(electbl$datetime,"%e/%m/%Y %H:%M:%S")

png(filename="plot3.png")

# set rows and columns
par(mfrow=c(1,1))

#Plot without data
plot(x=electbl$datetime,electbl$Sub_metering_1,type="n", xlab = "", ylab="Energy Sub Metering")

# Add lines with data
lines(electbl$datetime,electbl$Sub_metering_1,col="black")
lines(electbl$datetime,electbl$Sub_metering_2,col="red")
lines(electbl$datetime,electbl$Sub_metering_3,col="blue")

#Add Legend
legend("topright",col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty =c(1,1))

dev.off()
