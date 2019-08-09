library(raster)
library(rgdal)
library(SpaDES)

brick = brick('F:/Predictive_Modelling/S2_Scene/Mask/S2A_MSIL1C_20180820T153621_N0206_R068_T18NUJ_20180820T210738_S2C_resampled_msk.tif')
brick
band = subset(brick, 3)
band = band[band > -Inf]
NAvalue(band)
band
plot(band)

#get tiles
tiles = splitRaster(band, 10, 10)
frequency = NA
i = 1
for(tile in tiles){
  frequency[i] = freq(tiles[[i]])
}
frequency

freq(tiles)
plot(tiles[[50]])

test = tiles[[50]][tiles[[50]]>-Inf]
plot(test)

#try to get points for only non na values
points = rasterToPoints(band, function(x){x > 0}, spatial=TRUE)

writeOGR(obj=points, dsn='F:/Predictive_Modelling/Vector_Data', layer='Cell_Centroids', driver='ESRI Shapefile')


points
plot(points)

writeOGR()
spp

#plot a subset to test (it is still bringing in na values)


p2 = as(p, 'SpatialPointsDataFrame')

#subset to test


plot(p)


pix = as(band, 'SpatialPixelsDataFrame')
class(pix)
grid_center = coordinates(pix)
grid_center[0:10,]
centers = SpatialPoints(grid_center)
centers
#plot(centers[0:1000000,])
