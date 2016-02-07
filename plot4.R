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

# set the device
png(filename="plot4.png")

# set margins, no. of columns and rows
par(mfrow=c(2,2), mar=c(5,5,2,2))

# Plot row 1 col 1
plot(electbl$datetime,electbl$Global_active_power,type="n", xlab = "", ylab="Global Active Power (kilowatts)")
lines(electbl$datetime,electbl$Global_active_power)

#Plot row 1 col 2
plot(electbl$datetime,electbl$Voltage,type="n", xlab = "datetime", ylab="Voltage")
lines(electbl$datetime,electbl$Voltage)

#plot row 2 col 1
plot(x=electbl$datetime,electbl$Sub_metering_1,type="n", xlab = "", ylab="Energy Sub Metering")
lines(electbl$datetime,electbl$Sub_metering_1,col="black")
lines(electbl$datetime,electbl$Sub_metering_2,col="red")
lines(electbl$datetime,electbl$Sub_metering_3,col="blue")

legend("topright",col=c("black","red","blue"),
       legend=c("Sub_metring_1","Sub_metering_2","Sub_metering_3"),lty =c(1,1),sca)

#plot row 2 col 2

plot(electbl$datetime,electbl$Global_reactive_power,type="n", xlab = "datetime", ylab="Global_reactive_power")
lines(electbl$datetime,electbl$Global_reactive_power)
dev.off()
