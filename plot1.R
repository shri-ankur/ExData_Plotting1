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
head(power)
tail(power)
str(power)
summary(power)

power$Date1 <- as.Date(power$Date,"%d/%m/%Y")

png(filename="plot1.png", width = 480, height = 480, units = "px")
hist(power$Global_active_power,col="red", xlab="Global Active Power (kilowatts)",
     main="Global Active Power")
dev.off()

