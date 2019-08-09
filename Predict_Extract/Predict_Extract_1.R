library(raster)
library(rgal)

#could predict within 10 km of study site?

pts = readOGR(dsn='F:/Predictive_Modelling/Vector_Data', layer='Cell_Centroids')

brick = brick('F:/Predictive_Modelling/S2_Scene/Mask/S2A_MSIL1C_20180820T153621_N0206_R068_T18NUJ_20180820T210738_S2C_resampled_msk.tif')
brick
band = subset(brick, 3)

plot(pts[1:10,])

#extracting 10 points
start_time = Sys.time()
extract_test = extract(band, pts[1:10,])
end_time = Sys.time()

te = as(end_time - start_time, 'numeric')


n = 3256972
time = (((n/10) * te)/60)/60

#it will take 131 hrs per raster, approx 30 rasters
((time * 30)/24)

#This is not feasible
