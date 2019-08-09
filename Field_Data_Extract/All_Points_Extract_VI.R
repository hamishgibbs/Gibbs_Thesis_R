library(raster)
library(rgdal)

fw_points = readOGR(dsn = "/Volumes/Gibbs_Drive/Data_Master", layer = "Points_S2")

points = fw_points

study_dates = c('8/10/18', '8/17/18', '8/24/18', '9/28/18', '10/26/18', '11/2/18', '11/9/18')
folder_names = c('0403_TIFF', '0738_TIFF', '5020_TIFF', '0131_TIFF', '3259_TIFF', '0020_TIFF', '1115_TIFF')

#Look into a folder and get the names of all available indices
indices = list.files('/Volumes/Gibbs_Drive/S2_Data_Palmira/Vegetation_Indices/0020_TIFF')

i = 1
for(str in indices){
  indices[i] = unlist(strsplit(str, split='.', fixed=TRUE))[1]
  i = i + 1
}

#List of the available indices - used to make filenames and name columns
indices
length(indices)

#Fill points with blank columns for extracted values
points@data[,indices] = NA

#Make filenames with the indices
paths = paste('/Volumes/Gibbs_Drive/S2_Data_Palmira/Vegetation_Indices/', folder_names, '/', sep='')
files = paste(indices, '.tif', sep='')

#file names stored in a list of lists
full_paths = list()
i = 1
for(path in paths){
  full_paths[i] = list(paste(path, files, sep=''))
  i = i + 1
  }
full_paths[[1]]

#Made 140 files to search for
length(full_paths) * length(full_paths[[1]])

#for each date, open each raster, extract vals for that date, put into points
S2_VI_Extract <- function(date, points, brick, vi){
    band = subset(brick, 1)
    #Extract raster values for points on this date
    band_data = extract(band, points[points$date == date,])
    #Get the index for rows matching this date
    index = as.numeric(rownames(points[points$date == date,]@data))
    
    points[index, which(names(points)==vi)] = band_data
    return(points)
  }

#Before running through folders - need to make sure that the correct dates are being matched
new_pts = points

for(a in 1:length(study_dates)){
  for(i in 1:length(indices)){
    import_raster = brick(full_paths[[a]][i])
  
    print(paste('Reading File: ', full_paths[[a]][i], sep=''))
    
    new_pts = S2_VI_Extract(study_dates[a], new_pts, import_raster, indices[i])
  }
}

writeOGR(obj=new_pts, dsn="/Volumes/Gibbs_Drive/Data_Master", layer="Points_S2_VI", driver="ESRI Shapefile")

new_pts@data[30:40,]

new_pts@data$arvi
is.na(new_pts@data$arvi)
new_pts@data[4,]
plot(new_pts@data[1,24:33])

which(names(points)==indices[1])
