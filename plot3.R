# Using the data from the EPA on fine particulate matter, the below script
# will answer the the following question
# Of the four types of sources indicated by the type (point, 
# nonpoint, onroad, nonroad) variable, which of these four sources 
# have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008?

# download the data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",dest="emission.zip",method="curl")
unzip("emission.zip")

# load ggplot2
library(ggplot2)

# read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# subset the data for only baltimore
# compute the summary of emissions per type per year
emissions_baltimore <- NEI[NEI$fips == "24510",]
emissions_baltimore_by_type <- aggregate(emissions_baltimore$Emissions,list(emissions_baltimore$type,emissions_baltimore$year),sum)
names(emissions_baltimore_by_type) <- c("type","year","emissions")

# write out the graph
png("plot3.png",width=580,height=480)
qplot(year,emissions,data=emissions_baltimore_by_type,geom=c("point","line"),color=type,main="Emissions by Type in Baltimore, MD")
dev.off()