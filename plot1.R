# Using the data from the EPA on fine particulate matter, the below script
# will answer the the following question
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

# download the data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",dest="emission.zip",method="curl")
unzip("emission.zip")

# read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset the data and calculate the summary per year
emissions_per_year <- aggregate(NEI$Emissions,list(NEI$year),sum)

# write out the graph
png("plot1.png",width=500,height=400)
plot(emissions_per_year$x,type="l",axes=FALSE,ylab="Emissions",xlab="Year",main="Total Emissions Per Year in the US",ylim=c(2000000,8000000))
axis(2,cex.axis=.8,las=1,at=seq(2000000,8000000,2000000),labels=c("2M","4M","6M","8M"))
axis(1,at=seq(0,4,1),labels=c("","1999","2002","2005","2008"))
box()
dev.off()
