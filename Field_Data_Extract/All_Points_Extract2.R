library(raster)
library(rgdal)

#Read in point shapefile
fw_points = readOGR(dsn = "/Volumes/Gibbs_Drive/Data_Master", layer = "Points")
dim(fw_points)

points = fw_points

#Store all study dates - the dates the field work took place
study_dates = c('8/10/18', '8/17/18', '8/24/18', '9/28/18', '10/26/18', '11/2/18', '11/9/18')

#Band names
bands = c('B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B8A', 'B11', 'B12')

#Number of layers to read from (first 10 bands)
layer_num = length(bands)

#Create new column for each band to be written to
points@data[,bands] = NA


#Create raster brick of different raster layers
import_raster = brick('/Volumes/Gibbs_Drive/S2_Data_Palmira/S2_Subset_GeoTIFF/subset_0_of_S2A_MSIL1C_20180810T153621_N0206_R068_T18NUJ_20180810T210403_S2C_resampled.tif')

#Function to extract values from a series of bands(used for sentinel images)
S2_Band_Extract <- function(date, points, brick){
  
  for(i in 1:layer_num){
    print(paste('Extracting Band #', i, sep=""))
    band = subset(brick, i)
    #Extract raster balues for points on this date
    band_data = extract(band, points[points$date == date,])
    
    #Get the index for rows matching this date
    index = as.numeric(rownames(points[points$date == study_dates[1],]@data))
    
    points[index, 23 + i] = band_data
    
  }
  
  #Get the index of the records mathching this date
  index = as.numeric(rownames(points[points$date == study_dates[1],]@data))
  #Fill these rows with the extracted data
  points[index, 1] = band_data
  
  return(points)
  
}

#The order of the files must match the study date they relate to
file_names = c(
  '/Volumes/Gibbs_Drive/S2_Data_Palmira/S2_Subset_GeoTIFF/subset_0_of_S2A_MSIL1C_20180810T153621_N0206_R068_T18NUJ_20180810T210403_S2C_resampled.tif',
  '/Volumes/Gibbs_Drive/S2_Data_Palmira/S2_Subset_GeoTIFF/subset_1_of_S2A_MSIL1C_20180820T153621_N0206_R068_T18NUJ_20180820T210738_S2C_resampled.tif',
  '/Volumes/Gibbs_Drive/S2_Data_Palmira/S2_Subset_GeoTIFF/subset_2_of_S2B_MSIL1C_20180825T153609_N0206_R068_T18NUJ_20180825T205020_S2C_resampled.tif',
  '/Volumes/Gibbs_Drive/S2_Data_Palmira/S2_Subset_GeoTIFF/subset_3_of_S2A_MSIL1C_20180929T153621_N0206_R068_T18NUJ_20180929T190131_S2C_resampled.tif',
  '/Volumes/Gibbs_Drive/S2_Data_Palmira/S2_Subset_GeoTIFF/subset_5_of_S2B_MSIL2A_20181024T153619_N0206_R068_T18NUJ_20181024T203259_S2C_resampled.tif',
  '/Volumes/Gibbs_Drive/S2_Data_Palmira/S2_Subset_GeoTIFF/subset_6_of_S2B_MSIL1C_20181103T153619_N0206_R068_T18NUJ_20181103T190020_S2C_resampled.tif',
  '/Volumes/Gibbs_Drive/S2_Data_Palmira/S2_Subset_GeoTIFF/subset_4_of_S2A_MSIL2A_20181108T153611_N0207_R068_T18NUJ_20181108T191115_S2C_resampled.tif'
)

for(i in 1:length(file_names)){
  import_raster = brick(file_names[i])
  print(paste('Reading File: ', file_names[i], sep=''))
  if(i == 1){new_pts = points}else{new_pts=new_pts}
  new_pts = S2_Band_Extract(study_dates[i], new_pts, import_raster)
}

s2_dates = c('8/10/18', '8/20/18', '8/25/18', '9/29/18', '10/24/18', '11/3/18', '11/8/18')

new_pts = S2_Band_Extract(study_dates[1], points, import_raster)

new_pts[new_pts$date == study_dates[1],]@data

new_pts@data[30:40,]
