library(raster)
library(rgdal)

fw_points = readOGR(dsn = "/Volumes/Gibbs_Drive/Data_Master", layer = "Points_S2_VI")

points = fw_points

#Band names
bands = c('Sigma0_VH_Norm', 'Sigma0_VV_Norm')

layer_num = length(bands)

#Create new column for each band to be written to
points@data[,bands] = NA

#Field work dates
study_dates = c('8/10/18', '8/17/18', '8/24/18', '9/28/18', '10/26/18', '11/2/18', '11/9/18')

S1_dates = c('8/1/18', '8/13/18', '8/25/18', '9/30/18', '10/24/18', '11/5/18', '11/10/18')

file_names = c(
  '/Volumes/Gibbs_Drive/S1_Data_Palmira/S1_Subset_GeoTIFF_2/subset_4_of_S1B_IW_GRDH_1SDV_20180801T105053_20180801T105118_012068_01638A_9104_Orb_NR_Cal_ML_Spk_TC.tif',
  '/Volumes/Gibbs_Drive/S1_Data_Palmira/S1_Subset_GeoTIFF_2/subset_3_of_S1B_IW_GRDH_1SDV_20180813T105053_20180813T105118_012243_0168EF_E155_Orb_NR_Cal_ML_Spk_TC.tif',
  '/Volumes/Gibbs_Drive/S1_Data_Palmira/S1_Subset_GeoTIFF_2/subset_1_of_S1B_IW_GRDH_1SDV_20180825T105054_20180825T105119_012418_016E5A_8DBC_Orb_Cal_ML_Spk_TC.tif',
  '/Volumes/Gibbs_Drive/S1_Data_Palmira/S1_Subset_GeoTIFF_2/subset_0_of_S1B_IW_GRDH_1SDV_20180930T105055_20180930T105120_012943_017E7D_4E7B_Orb_NR_Cal_ML_Spk_TC.tif',
  '/Volumes/Gibbs_Drive/S1_Data_Palmira/S1_Subset_GeoTIFF_2/subset_5_of_S1B_IW_GRDH_1SDV_20181024T105056_20181024T105121_013293_018938_6765_Orb_Cal_ML_Spk_TC.tif',
  '/Volumes/Gibbs_Drive/S1_Data_Palmira/S1_Subset_GeoTIFF_2/subset_6_of_S1B_IW_GRDH_1SDV_20181105T105055_20181105T105120_013468_018EB7_A665_Orb_Cal_ML_Spk_TC.tif',
  '/Volumes/Gibbs_Drive/S1_Data_Palmira/S1_Subset_GeoTIFF_2/subset_7_of_S1B_IW_GRDH_1SDV_20181110T232105_20181110T232130_013549_019134_523D_Orb_Cal_ML_Spk_TC.tif'
)

S1_Band_Extract <- function(date, points, brick){
  #brick <- projectRaster(brick, crs = crs(points))
  
  for(i in 1:layer_num){
    print(paste('Extracting Band #', 4 + i, sep=""))
    
    band = subset(brick, 4 + i)
    #band = projectRaster(band, crs = crs(points))
    
    #Extract raster balues for points on this date
    band_data = extract(band, points[points$date == date,])
    
    #Get the index for rows matching this date
    index = as.numeric(rownames(points[points$date == date,]@data))
    
    points[index, 53 + i] = band_data

  }
  return(points)
}

new_pts = points

#Make sure dates match
for(i in 1:length(file_names)){
  import_raster = projectRaster(brick(file_names[i]), crs = crs(points))
  print(paste('Reading File: ', file_names[i], sep=''))
  new_pts = S1_Band_Extract(study_dates[i], new_pts, import_raster)
}

writeOGR(obj=new_pts, dsn="/Volumes/Gibbs_Drive/Data_Master", layer="Points_S2_VI_S1", driver="ESRI Shapefile")

new_pts
new_pts@data

new_pts@data[70:80,]


#want bands 5 and 6
import_raster = brick(file_names[1])
band = subset(import_raster, 6)
plot(band)
