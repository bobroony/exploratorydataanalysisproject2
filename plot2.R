# Using the data from the EPA on fine particulate matter, the below script
# will answer the the following question
# Have total emissions from PM2.5 decreased in 
# Baltimore City, Maryland from 1999 to 2008?

# download the data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",dest="emission.zip",method="curl")
unzip("emission.zip")

# read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# subset the data for baltimore maryland and calculate the sum per year
emissions_baltimore <- NEI[NEI$fips == "24510",]
emissions_baltimore_per_year <- aggregate(emissions_baltimore$Emissions,list(emissions_baltimore$year),sum)

# write out the graph
png("plot2.png",width=500,height=400)
plot(emissions_baltimore_per_year$x,type="l",axes=FALSE,ylab="Emissions",xlab="Year",main="Total Emissions Per Year in Baltimore, Maryland",ylim=c(1000,4000))
axis(2,cex.axis=.8,las=1,at=seq(1000,4000,1000),labels=c("1K","2K","3K","4K"))
axis(1,at=seq(0,4,1),labels=c("","1999","2002","2005","2008"))
box()
dev.off()