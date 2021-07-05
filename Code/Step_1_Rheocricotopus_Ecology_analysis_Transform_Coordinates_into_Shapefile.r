# Rheocricotopus
# this is the code to prepare shapefile for the distribution of Rheocricotopus 

# load the library
library(raster)
library(rgdal)
library(factoextra)
library(ggpubr)
library(data.table)

# read the distribution points from csv
distributionTable = read.csv("Data/DistributionPointsData/distribution_new.csv")
# make a copy of the table to store the data, and remove the points with out coordinates infromation
dupilcateTable = na.omit(distributionTable[,c("Lat","Lon","Sample.ID")])
# allote the coordinates
coordinates(dupilcateTable) = ~Lon+Lat
# allocate projection system
proj4string(dupilcateTable) = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
dupilcateTable@data =  na.omit(distributionTable[,c("Lat","Lon","Sample.ID","Continent","Country.Ocean")])
# write the shapefile into local folder
writeOGR(dupilcateTable,dsn="Data",layer="Rheocricotopus_Distribution", driver = "ESRI Shapefile",overwrite=T)



