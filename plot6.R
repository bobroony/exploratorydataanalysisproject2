# Compare emissions from motor vehicle sources in Baltimore City 
# with emissions from motor vehicle sources in Los Angeles County, California 
# Which city has seen greater changes over time in motor vehicle emissions?

# download the data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",dest="emission.zip",method="curl")
unzip("emission.zip")

# load ggplot2
library(ggplot2)
library(grid)

# read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# grab motor vehicle related SCCs
indices <- grep("Vehicle",SCC$Short.Name)
sccs <- SCC[indices,]

# extract emissions data matching the specific SCCs in baltimore and Los Angeles
matching_scc_ba <- NEI[NEI$SCC %in% unlist(sccs["SCC"]) & NEI$fips == 24510,]
matching_scc_la <- NEI[NEI$SCC %in% unlist(sccs["SCC"]) & NEI$fips == "06037",]

# summarize the data, append the percent change for each
# year,append a column for city name
summ_ba <- aggregate(matching_scc_ba$Emissions,list(matching_scc_ba$year),sum)
summ_la <- aggregate(matching_scc_la$Emissions,list(matching_scc_la$year),sum)
changes_la <- Delt(summ_la$x)
changes_ba <- Delt(summ_ba$x)
changes_la <- changes_la * 100
changes_ba <- changes_ba * 100
summ_la <- cbind(summ_la,changes_la)
summ_ba <- cbind(summ_ba,changes_ba)
summ_la <- cbind(summ_la,rep("Los Angeles",4))
names(summ_la) <- c("year","emissions","change","city")
summ_ba <- cbind(summ_ba,rep("Balitmore",4))
names(summ_ba) <- c("year","emissions","change","city")

# create one dataset
all <- rbind(summ_la,summ_ba)

# graph the changes
png("plot6.png",width=780,height=580)
a <- qplot(year,emissions,data=all,geom=c("point","line"),color=city,main="Changes in Total Motor Vehicle Emissions in Baltimore, MD and Los Angeles, CA")
b <- qplot(year,change,data=all,color=city,geom=c("point","line"),main="Percent Changes in Total Motor Vehicle Emissions in Baltimore, MD and Los Angeles, CA")
grid.arrange(a,b)
dev.off()
