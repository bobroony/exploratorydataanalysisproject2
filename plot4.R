# Using the data from the EPA on fine particulate matter, the below script
# will answer the the following question
# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999–2008?

# download the data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",dest="emission.zip",method="curl")
unzip("emission.zip")

# read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# grab coal combustion related SCCs
indices <- grep("Coal",SCC$EI.Sector)
sccs <- SCC[indices,]

# extract emissions data matching the specific SCCs
matching_scc <- NEI[NEI$SCC %in% unlist(sccs["SCC"]),]

#summarize the data
summ <- aggregate(matching_scc$Emissions,list(matching_scc$year),sum)

# graph the changes
png("plot4.png",width=500,height=400)
plot(summ$x,type="l",axes=FALSE,ylab="Emissions",xlab="Year",main="Total Emissions Per Year from Coal Combustion in the US",ylim=c(300000,600000))
axis(2,cex.axis=.8,las=1,at=seq(300000,600000,100000),labels=c("300K","400K","500K","600K"))
axis(1,at=seq(0,4,1),labels=c("","1999","2002","2005","2008"))
box()
dev.off()

