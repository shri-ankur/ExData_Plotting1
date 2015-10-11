install.packages("sqldf")
library(sqldf)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), dbname= "sample_db.sqlite")

#read file into SQL database
dbWriteTable(con, name="sample_table", value="household_power_consumption.txt",
             row.names=FALSE, header=TRUE, sep=";")

power <- dbGetQuery(con, "select * from sample_table where date = '1/2/2007' or date = '2/2/2007'")
head(power)
tail(power)
str(power)
summary(power)

power$Date1 <- as.Date(power$Date,"%d/%m/%Y")
power$Datetime1 <- paste(power$Date,power$Time)
power$Datetime <- strptime(power$Datetime1,"%d/%m/%Y %H:%M:%S")

png(filename="plot2.png", width = 480, height = 480, units = "px")
plot(power$Datetime,power$Global_active_power, pch=".", ylab="Global Active Power (kilowatts)",
     xlab="")
lines(power$Datetime, power$Global_active_power)
dev.off()



