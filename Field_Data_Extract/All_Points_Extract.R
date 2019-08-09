library(spatial)
library(raster)
library(rgdal)

#Read in point shapefile
fw_points = readOGR(dsn = "/Volumes/Gibbs_Drive/Data_Master", layer = "Points")
plot(fw_points)

#Store all study dates
study_dates = c('8/10/18', '8/17/18', '8/24/18', '9/28/18', '10/26/18', '11/2/18', '11/9/18')

plot(fw_points[fw_points$date == study_dates[1],])

#Band names
bands = c('B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B8A', 'B11', 'B12')

#Create raster brick of different raster layers
import_raster = brick('/Volumes/Gibbs_Drive/S2_Data_Palmira/S2_Subset_GeoTIFF/subset_0_of_S2A_MSIL1C_20180810T153621_N0206_R068_T18NUJ_20180810T210403_S2C_resampled.tif')
nlayers(import_raster)

band = subset(import_raster, 4)
plot(band)

#Function to extract values from a series of bands(used for sentinel images)
S2_Band_Extract <- function(date, points, brick, bands){
  #Remember to replace 1s with i's in loop
  band = subset(brick, 1)
  points@data[,bands] = NA
  #Extract band data for points on this date
  band_data = extract(raster, points[points$date == study_dates[1],])
  #Create a new column to store this data
  points$name = NA
  #Get the index of the records mathching this date
  index = as.numeric(rownames(points[points$date == study_dates[1],]@data))
  #Fill these rows with the extracted data
  points[index, 1] = band_data
  
  return(points)
  
}

#Test extract raster values to points
s2_test = raster('/Volumes/Gibbs_Drive/S2_Data_Palmira/S2_Subset_GeoTIFF/subset_0_of_S2A_MSIL1C_20180810T153621_N0206_R068_T18NUJ_20180810T210403_S2C_resampled.tif')

points2 = points
plot(s2_test)

#Extract band data for points on this date
band_data = extract(s2_test, points2[points2$date == study_dates[1],])
#Create a new column to store this data
points2$B1 = NA
#Get the index of the records mathching this date
index = as.numeric(rownames(points2[points2$date == study_dates[1],]@data))
#Fill these rows with the extracted data
points2$B1[index] = band_data

names = c('B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B8A', 'B11', 'B12')
name = names[3]

dim(points2)

points2@data[,27] = NA

points2@data[,c('B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B8A', 'B11', 'B12')] = NA


points2@data
