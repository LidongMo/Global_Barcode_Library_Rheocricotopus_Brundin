# Rheocricotopus

# STEP 2 read the covraites table
library(raster)
library(rgdal)
library(factoextra)
library(ggpubr)
library(data.table)
library(corrplot)
# set the working directory

trainTable = fread("Data/DataWithCovariates/20210319_Rheocricotopus_Covariates_samppling_to_drive.csv")
# define the covariates vector
covariatesVector = c('CHELSA_BIO_Annual_Mean_Temperature','CHELSA_BIO_Annual_Precipitation','CHELSA_BIO_Isothermality','CHELSA_BIO_Max_Temperature_of_Warmest_Month','CHELSA_BIO_Mean_Diurnal_Range','CHELSA_BIO_Mean_Temperature_of_Coldest_Quarter','CHELSA_BIO_Mean_Temperature_of_Driest_Quarter','CHELSA_BIO_Mean_Temperature_of_Warmest_Quarter','CHELSA_BIO_Mean_Temperature_of_Wettest_Quarter','CHELSA_BIO_Min_Temperature_of_Coldest_Month','CHELSA_BIO_Precipitation_Seasonality','CHELSA_BIO_Precipitation_of_Coldest_Quarter','CHELSA_BIO_Precipitation_of_Driest_Month','CHELSA_BIO_Precipitation_of_Driest_Quarter','CHELSA_BIO_Precipitation_of_Warmest_Quarter','CHELSA_BIO_Precipitation_of_Wettest_Month','CHELSA_BIO_Precipitation_of_Wettest_Quarter','CHELSA_BIO_Temperature_Annual_Range','CHELSA_BIO_Temperature_Seasonality','CHELSA_exBIO_FrostChangeFrequency','CHELSA_exBIO_FrostDays','CGIAR_Aridity_Index','EarthEnvCloudCover_Mean','EarthEnvTexture_Shannon_Index','EarthEnvTexture_Simpson_Index','EarthEnvTopoMed_Elevation','EsaCci_SnowProbability','EarthEnvTopoMed_Slope','FanEtAl_Depth_to_Water_Table_AnnualMean','GPWv4_Population_Density','HansenEtAl_TreeCover_Year2010','MODIS_GPP','MODIS_NDVI')

# subset the table for PCA
subsetTrainTable = na.omit(subset(trainTable,select=c("Contnnt",covariatesVector)))
# apply the pca
pcaResult = prcomp(subsetTrainTable[,-1],center = TRUE,scale. = TRUE) 
pdf("Plots/Figure_x_PCA_Result_with_variable_Contribution_and_Points_Top_10.pdf",width=11,height=10)
fviz_pca_biplot(pcaResult, label="var", habillage=subsetTrainTable$Contnnt,select.var = list(contrib = 10),addEllipses=TRUE, ellipse.level=0.95)+ scale_color_brewer(palette="Dark2")
dev.off()

pdf("Plots/Figure_x_PCA_Result_with_Points.pdf",width=11,height=10)
fviz_pca_ind(pcaResult, label="none", habillage=subsetTrainTable$Contnnt,addEllipses=TRUE, ellipse.level=0.95)+ scale_color_brewer(palette="Dark2")
dev.off()


cor.matrix = cor(subset(subsetTrainTable,select=covariatesVector))
cor.dist = abs(as.dist(cor.matrix))
cor.cluster = hclust(1-cor.dist)
plot(cor.cluster)

pdf("Plots/Figure_X_Hclust_for_Covariates.pdf",height=8,width=14)
plot(cor.cluster)
dev.off()

# selected variables

# top 10 contribution vars 
topVars = c("CHELSA_BIO_Mean_Temperature_of_Warmest_Quarter","CHELSA_BIO_Annual_Precipitation","EsaCci_SnowProbability","CHELSA_BIO_Precipitation_of_Wettest_Quarter","CHELSA_BIO_Precipitation_of_Wettest_Month","MODIS_GPP","CHELSA_exBIO_FrostDays","CHELSA_BIO_Min_Temperature_of_Coldest_Month","CHELSA_BIO_Annual_Mean_Temperature","CHELSA_BIO_Mean_Temperature_of_Coldest_Quarter")
corMatrix = cor(subset(subsetTrainTable,select=topVars))
pdf("Plots/Figure_X_Correlation_Matrix_of_10_vars.pdf",height=10,width=10)
corrplot.mixed(corMatrix)
dev.off()

retainedVars = c("CHELSA_BIO_Annual_Precipitation","CHELSA_BIO_Annual_Mean_Temperature")
corMatrix = cor(subset(subsetTrainTable,select=retainedVars))
pdf("Plots/Figure_X_Correlation_Matrix_of_retained_vars.pdf",height=10,width=10)
corrplot.mixed(corMatrix)
dev.off()


p1 = ggplot(subsetTrainTable, aes(x=CHELSA_BIO_Annual_Precipitation, fill=Contnnt)) +scale_fill_brewer(palette="Dark2")+
  geom_density(alpha=0.3)+theme_classic()+theme(legend.position=c(0.9,0.8))
p2 = ggplot(subsetTrainTable, aes(x=CHELSA_BIO_Annual_Mean_Temperature, fill=Contnnt)) +scale_fill_brewer(palette="Dark2")+
  geom_density(alpha=0.3)+theme_classic()+theme(legend.position=c(0.9,0.8))

pdf("Plots/Figure_x_Temp_and_Precip_density_plots.pdf",width =10, height=5)
library("gridExtra")
ggarrange(p1,p2, ncol =2, nrow = 1)
dev.off()



