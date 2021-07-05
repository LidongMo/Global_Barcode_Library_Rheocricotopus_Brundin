// load the composite
var compositeImage = ee.Image("projects/crowtherlab/Composite/CrowtherLab_Composite_30ArcSec");
// print the band names
print(compositeImage.bandNames())

// load the dirtribution points of Rheocricotopus
var distributionTable = ee.FeatureCollection("users/leonidmoore/Rheocricotopus_Distribution");
Map.addLayer(distributionTable,{color:'blue'},"Original Distribution Points",true);

// define the vector of the variables we need to extract
var covariatesVector = ['CHELSA_BIO_Annual_Mean_Temperature',
                        'CHELSA_BIO_Annual_Precipitation',
                        'CHELSA_BIO_Isothermality',
                        'CHELSA_BIO_Max_Temperature_of_Warmest_Month',
                        'CHELSA_BIO_Mean_Diurnal_Range',
                        'CHELSA_BIO_Mean_Temperature_of_Coldest_Quarter',
                        'CHELSA_BIO_Mean_Temperature_of_Driest_Quarter',
                        'CHELSA_BIO_Mean_Temperature_of_Warmest_Quarter',
                        'CHELSA_BIO_Mean_Temperature_of_Wettest_Quarter',
                        'CHELSA_BIO_Min_Temperature_of_Coldest_Month',
                        'CHELSA_BIO_Precipitation_Seasonality',
                        'CHELSA_BIO_Precipitation_of_Coldest_Quarter',
                        'CHELSA_BIO_Precipitation_of_Driest_Month',
                        'CHELSA_BIO_Precipitation_of_Driest_Quarter',
                        'CHELSA_BIO_Precipitation_of_Warmest_Quarter',
                        'CHELSA_BIO_Precipitation_of_Wettest_Month',
                        'CHELSA_BIO_Precipitation_of_Wettest_Quarter',
                        'CHELSA_BIO_Temperature_Annual_Range',
                        'CHELSA_BIO_Temperature_Seasonality',
                        'CHELSA_exBIO_FrostChangeFrequency',
                        'CHELSA_exBIO_FrostDays',
                        'CGIAR_Aridity_Index',
                        'EarthEnvCloudCover_Mean',
                        'EarthEnvTexture_Shannon_Index',
                        'EarthEnvTexture_Simpson_Index',
                        'EarthEnvTopoMed_Elevation',
                        'EsaCci_SnowProbability',
                        'EarthEnvTopoMed_Slope',
                        'FanEtAl_Depth_to_Water_Table_AnnualMean',
                        'GPWv4_Population_Density',
                        'HansenEtAl_TreeCover_Year2010',
                        'MODIS_GPP',
                        'MODIS_NDVI',
                        'WWF_Biome'];


var sampledCollection = distributionTable.map(function(f){
  return f.set(compositeImage.select(covariatesVector).reduceRegion('first',f.geometry()));
});
// show the sampled results
print("sampled data head",sampledCollection.limit(5));


Export.table.toDrive({
	collection: sampledCollection,
	description:'Rheocricotopus_Covaraites_Samppling',
	fileNamePrefix: '20210319_Rheocricotopus_Covariates_samppling_to_drive.csv',
});