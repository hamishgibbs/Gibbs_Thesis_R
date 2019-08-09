library(raster)
library(rgdal)
library(sp)
library(rgeos)

#import raster
crop_data = raster('F:/Predictive_Modelling/Land_Cover_Map/W080N20_ProbaV_LC100_epoch2015_global_v2.0.1_crops-coverfraction-layer_EPSG-4326.tif')

#check data
plot(crop_data)

#get extent of s1 scene
s1_scene = raster('/Volumes/Gibbs_Drive/Predictive_Modelling/S1_Scene/GeoTIFF/S1B_IW_GRDH_1SDV_20180813T105053_20180813T105118_012243_0168EF_E155_Orb_NR_Cal_ML_Spk_TC.tif')
s1_extent = extent(s1_scene)

#save extent to vector
plot(s1_extent)
#s1_extent = as(s1_extent, 'SpatialPolygonsDataFrame')
writeOGR(obj=s1_extent, dsn="/Volumes/Gibbs_Drive/Predictive_Modelling/Vector_Data", layer="S1_Extent", driver="ESRI Shapefile")

#get extent of s2 scene
s2_scene = raster('F:/Predictive_Modelling/S2_Scene/Geotiff/subset_0_of_S2A_MSIL1C_20180820T153621_N0206_R068_T18NUJ_20180820T210738_S2C_resampled.tif')
s2_extent = as(extent(s2_scene), "SpatialPolygons")
sr = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
crs(s2_extent) = crs(s2_scene)
s2_extent_ll = spTransform(s2_extent, CRS(sr))
s2_extent_ll = as(s2_extent_ll, 'SpatialPolygonsDataFrame')
writeOGR(obj=s2_extent_ll, dsn='F:/Predictive_Modelling/Vector_Data', layer='S2_Extent', driver='ESRI Shapefile')

#find overlapping area of s1 and s2

#save this as poly

#clip crop raster to this poly
mask <- crop(crop_data, s2_extent_ll)
plot(mask)

#Get cells that are greater than 80% cropland
crop_80= mask >= 80

plot(crop_80)

#convert to vector
crop_80_v = rasterToPolygons(crop_80, fun=function(x){x==1}, dissolve = TRUE)

writeOGR(obj=crop_80_v, dsn='F:/Predictive_Modelling/Vector_Data', layer='Crop_80_Poly', driver='ESRI Shapefile')
