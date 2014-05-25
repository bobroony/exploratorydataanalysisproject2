# Using the data from the EPA on fine particulate matter, the below script
# will answer the the following question
# How have emissions from motor vehicle sources changed from 1999–2008 
# in Baltimore City?

# download the data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",dest="emission.zip",method="curl")
unzip("emission.zip")

# read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# grab motor vehicle related SCCs
indices <- grep("Vehicle",SCC$Short.Name)
sccs <- SCC[indices,]

# extract emissions data matching the specific SCCs in baltimore
matching_scc <- NEI[NEI$SCC %in% unlist(sccs["SCC"]) & NEI$fips == 24510,]

# summarize the data
summ <- aggregate(matching_scc$Emissions,list(matching_scc$year),sum)

# graph the changes
png("plot5.png",width=500,height=400)
plot(summ$x,type="l",axes=FALSE,ylab="Emissions",xlab="Year",main="Total Emissions Per Year from Motor Vehicles in Baltimore, MD",ylim=c(0,100))
axis(2,cex.axis=.8,las=1,at=seq(0,100,25),labels=c("0","25","50","75","100"))
axis(1,at=seq(0,4,1),labels=c("","1999","2002","2005","2008"))
box()
dev.off()

