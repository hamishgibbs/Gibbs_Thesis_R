library(raster)
library(rgdal)

fw_points = readOGR(dsn = "/Volumes/Gibbs_Drive/Data_Master", layer = "Points_S2_VI_S1")

points = fw_points

#Band names
bands = c('lai', 'lai_cab', 'lai_cw', 'fapar', 'fcover')

layer_num = length(bands)

#Create new column for each band to be written to
points@data[,bands] = NA

study_dates = c('8/10/18', '8/17/18', '8/24/18', '9/28/18', '10/26/18', '11/2/18', '11/9/18')

path = '/Volumes/Gibbs_Drive/S2_Data_Palmira/Products_Test/'

files = c(
  'subset_0_of_S2A_MSIL1C_20180810T153621_N0206_R068_T18NUJ_20180810T210403_S2C_resampled_biophysical.tif',
  'subset_1_of_S2A_MSIL1C_20180820T153621_N0206_R068_T18NUJ_20180820T210738_S2C_resampled_biophysical.tif',
  'subset_2_of_S2B_MSIL1C_20180825T153609_N0206_R068_T18NUJ_20180825T205020_S2C_resampled_biophysical.tif',
  'subset_3_of_S2A_MSIL1C_20180929T153621_N0206_R068_T18NUJ_20180929T190131_S2C_resampled_biophysical.tif',
  'subset_5_of_S2B_MSIL2A_20181024T153619_N0206_R068_T18NUJ_20181024T203259_S2C_resampled_biophysical.tif',
  'subset_6_of_S2B_MSIL1C_20181103T153619_N0206_R068_T18NUJ_20181103T190020_S2C_resampled_biophysical.tif',
  'subset_4_of_S2A_MSIL2A_20181108T153611_N0207_R068_T18NUJ_20181108T191115_S2C_resampled_biophysical.tif'
)

#create full paths to open files
file_names = paste(path, files, sep='')
file_names

s2_dates = c('8/10/18', '8/20/18', '8/25/18', '9/29/18', '10/24/18', '11/3/18', '11/8/18')

BP_Band_Extract <- function(date, points, brick){
  
  i = 1
  for(num in seq(1, (layer_num*2), by=2)){
    print(paste('Extracting Band #', num, sep=""))
    
    band = subset(brick, num)
    
    #Extract raster balues for points on this date
    band_data = extract(band, points[points$date == date,])
    
    #Get the index for rows matching this date
    index = as.numeric(rownames(points[points$date == date,]@data))
    
    points[index, 55 + i] = band_data
    
    i = i + 1
  }
  return(points)
}

new_pts = points

for(a in 1:length(file_names)){
  import_raster = brick(file_names[a])
  print(paste('Reading File: ', file_names[a], sep=''))
  new_pts = BP_Band_Extract(study_dates[a], new_pts, import_raster)
}

new_pts@data
new_pts@data[100:200,]

writeOGR(obj=new_pts, dsn="/Volumes/Gibbs_Drive/Data_Master", layer="Points_S2_VI_S1_BP", driver="ESRI Shapefile")

#See which bands are needed
#Need bands 1, 3, 5, 7, 9
import_raster = brick(file_names[1])
band = subset(import_raster, 9)
plot(band)



