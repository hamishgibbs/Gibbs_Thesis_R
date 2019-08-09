library(rgdal)
library(raster)

pts = readOGR(dsn='F:/Predictive_Modelling/Vector_Data', layer='10k_Points')

pts@data$S2A_MSI=NA

plot(pts)
#Extract for S2 images 

bands = c('B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B8A', 'B11', 'B12')

#Number of layers to read from (first 10 bands)
layer_num = length(bands)

brick = brick('F:/Predictive_Modelling/S2_Scene/Mask/S2A_MSIL1C_20180820T153621_N0206_R068_T18NUJ_20180820T210738_S2C_resampled_msk.tif')

for(i in 1:layer_num){
  print(paste('Extracting Band ', bands[i], sep=""))
  band = subset(brick, i)
  #Extract raster balues for points on this date
  band_data = extract(band, pts)
  
  #Get the index for rows matching this date
  index = as.numeric(rownames(pts@data))
  
  pts[index, i] = band_data
}

colnames(pts@data) = bands

pts@data

writeOGR(obj=pts, dsn='F:/Predictive_Modelling/Vector_Data', layer="10k_Points_S2", driver="ESRI Shapefile")

#Extract vis
indices = list.files('F:/Predictive_Modelling/S2_Scene/Vegetation_Indices')

i = 1
for(str in indices){
  indices[i] = unlist(strsplit(str, split='.', fixed=TRUE))[1]
  i = i + 1
}

#List of the available indices - used to make filenames and name columns
indices
length(indices)

#Fill points with blank columns for extracted values
pts@data[,indices] = NA

#Make filenames with the indices
path = 'F:/Predictive_Modelling/S2_Scene/Vegetation_Indices/'
files = paste(indices, '.tif', sep='')
fns = paste(path, files, sep='')

#for each date, open each raster, extract vals for that date, put into points
S2_VI_Extract <- function(points, brick, vi){
  band = subset(brick, 1)
  #Extract raster values for points on this date
  band_data = extract(band, points)
  #Get the index for rows matching this date
  index = as.numeric(rownames(points@data))
  
  points[index, which(names(points)==vi)] = band_data
  return(points)
}

new_pts = pts

for(i in 1:length(indices)){
  print(paste('Extracting ', indices[i], sep=""))
  import_raster = brick(fns[i])
  
  new_pts = S2_VI_Extract(new_pts, import_raster, indices[i])
}

head(new_pts)

writeOGR(obj=new_pts, dsn='F:/Predictive_Modelling/Vector_Data', layer="10k_Points_S2_VI", driver="ESRI Shapefile")
new_pts = readOGR(dsn='F:/Predictive_Modelling/Vector_Data', layer='10k_Points_S2_VI')

#read s1 data
bands = c('Sigma0_VH_Norm', 'Sigma0_VV_Norm')
layer_num = length(bands)

new_pts@data[,bands] = NA

S1_Band_Extract <- function(points, brick){
  for(i in 1:layer_num){
    print(paste('Extracting Band ', bands[i], sep=""))
    
    band = subset(brick, i)
    
    band_data = extract(band, points)
    
    #Get the index for rows matching this date
    index = as.numeric(rownames(points@data))
    
    points[index, 30 + i] = band_data
  }
  return(points)
}

import_raster = brick('F:/Predictive_Modelling/S1_Scene/Mask/S1B_IW_GRDH_1SDV_20180813T105053_20180813T105118_012243_0168EF_E155_Orb_NR_Cal_ML_Spk_TC_msk.tif')
new_pts = S1_Band_Extract(new_pts, import_raster)

head(new_pts)

writeOGR(obj=new_pts, dsn='F:/Predictive_Modelling/Vector_Data', layer="10k_Points_S2_VI_S1", driver="ESRI Shapefile")

#extract biophysical products

points = readOGR(dsn='F:/Predictive_Modelling/Vector_Data', layer='10k_Points_S2_VI_S1')

bands = c('lai', 'lai_cab', 'lai_cw', 'fapar', 'fcover')

layer_num = length(bands)

#Create new column for each band to be written to
points@data[,bands] = NA

BP_Band_Extract <- function(points, brick){
  i = 1
  for(num in seq(1, (layer_num*2), by=2)){
    print(paste('Extracting Band #', num, sep=""))
    
    band = subset(brick, num)
    
    #Extract raster balues for points on this date
    band_data = extract(band, points)
    
    #Get the index for rows matching this date
    index = as.numeric(rownames(points@data))
    
    points[index, 32 + i] = band_data
    
    i = i + 1
  }
  return(points)
}

import_raster = brick('F:/Predictive_Modelling/S2_Scene/Biophysical_Products/subset_0_of_S2A_MSIL1C_20180820T153621_N0206_R068_T18NUJ_20180820T210738_S2C_resampled_biophysical.tif')
new_pts = BP_Band_Extract(points, import_raster)
head(new_pts)
writeOGR(obj=new_pts, dsn='F:/Predictive_Modelling/Vector_Data', layer="10k_Points_S2_VI_S1_BP", driver="ESRI Shapefile")

