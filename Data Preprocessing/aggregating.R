
# This R script processes hourly data in NetCDF format for a specified spatial extent.
# It converts the hourly precipitation values to daily totals, crops the data to the extent of a specified shapefile,
# and saves the processed raster layers as new files.
# Users can customize the aggregation function and other parameters as needed.


# load libraries
library(ncdf4)   # For handling NetCDF files
library(raster)   # For raster data manipulation
library(sf)       # For handling spatial data (shapefiles)

# Specify the path to the shapefile representing the desired spatial extent if needed.
shp <- shapefile("/path/to/file/file.shp")

# Set the working directory to the folder containing the hourly NetCDF files
setwd("/path/to/files/")
files <- list.files(pattern = "*.nc")


# Iterate through each hourly NetCDF file and perform the necessary operations
for (i in 1:length(files)) {
  
  # Extract the file name for naming purposes (change based on your naming convention)
  fname <- substring(files[i], 1, nchar(files[i]) - 3)  
  
  # Read the NetCDF file as a raster brick
  brk <- brick(files[i])
  
  # Extract indices (dates) from the layer names (if needed)
  # Customize the indices (dates) based on your needs (e.g., daily, monthly, annual) in format.
  # In this case, it ignores the time part and only registers the date to achieve our goal of hourly to daily aggregate
  indices <- format(as.Date(names(brk), format = "X%Y.%m.%d"), format = "%d-%m-%y")
  
  # Convert hourly values to daily totals
  datasum_m <- stackApply(brk, indices, fun = sum)  # HOURLY TO DAILY

  # Uncomment the following lines if you want to extract a spatial subset based on the shapefile boundary
  # ------------------------------------------------------------- 
  # a <- crop(datasum_m, extent(shp) + .01)
  # b <- mask(datasum_m, shp)
  # ------------------------------------------------------------- 
  
  # Adjust layer names for consistency
  # change based on your specific naming convention.
  names(b) <- substring(names(b), 7, 14)
  
  # Write the processed raster as a new file in the specified folder
  outfile <- writeRaster(b, filename = paste0("/path/to/file/", fname, ".grd"))
}
