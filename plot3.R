#Install sqldf package to read only selected data in R
install.packages("sqldf")
library(sqldf)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), dbname= "sample_db.sqlite")

#read file into SQL database
dbWriteTable(con, name="sample_table", value="household_power_consumption.txt",
             row.names=FALSE, header=TRUE, sep=";")

#From SQL database, get only that data where date = '1/2/2007' or '2/2/2007'
power <- dbGetQuery(con, "select * from sample_table where date = '1/2/2007' or date = '2/2/2007'")

power$Date1 <- as.Date(power$Date,"%d/%m/%Y")
power$Datetime1 <- paste(power$Date,power$Time)
power$Datetime <- strptime(power$Datetime1,"%d/%m/%Y %H:%M:%S")

png(filename="plot3.png", width = 480, height = 480, units = "px")
plot(power$Datetime,power$Sub_metering_1, pch=".", ylab="Energy sub metering",
     xlab="", type="n")
lines(power$Datetime, power$Sub_metering_1)
lines(power$Datetime, power$Sub_metering_2, col="red")
lines(power$Datetime, power$Sub_metering_3, col="blue")
legend("topright", lwd=1, col=c("black","red","blue"), legend=c("Sub_metering_1",
                                        "Sub_metering_2", "Sub_metering_3"))
dev.off()
