library(rgdal)
library(rgeos)
library(sp)
library(spatial)
library(raster)

#Make a point file with all the points within 10 k of the study site
pts = readOGR(dsn='F:/Predictive_Modelling/Vector_Data', layer='Cell_Centroids')

boundary = readOGR(dsn='F:/Field_data/04_Colombia_results', layer='plot_boundary')
plot(boundary)
centroid = gCentroid(boundary)
centroid
plot(centroid, add=T)

buffer = gBuffer(centroid, width = 10000.0, byid=FALSE, capStyle = 'SQUARE')
plot(buffer)
buffer = as(buffer, 'SpatialPolygonsDataFrame')
buffer = SpatialPolygonsDataFrame(buffer, data=buffer@data)
writeOGR(obj=buffer, dsn='F:/Predictive_Modelling/Vector_Data', layer="10k_Buffer", driver="ESRI Shapefile")

points_crop = crop(pts, buffer)
points_crop

writeOGR(obj=points_crop, dsn='F:/Predictive_Modelling/Vector_Data', layer="10k_Points", driver="ESRI Shapefile")

plot(points_crop)

brick = brick('F:/Predictive_Modelling/S2_Scene/Mask/S2A_MSIL1C_20180820T153621_N0206_R068_T18NUJ_20180820T210738_S2C_resampled_msk.tif')
band = subset(brick, 3)


#extracting 10 points
start_time = Sys.time()
extract_test = extract(band, pts[1:10,])
end_time = Sys.time()

te = as(end_time - start_time, 'numeric')

n = 5755
time = (((n/10) * te)/60)

time 
#3 minutes per raster
time * 30
