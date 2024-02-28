
# This R script is designed to process NetCDF raster files by cropping, masking, and projecting them using the 'raster' and 'sf' packages.
# The code assumes the presence of a shapefile ('file.shp') to use as a mask and a reference NetCDF file ('file.nc') for projection. You can skip this part if not required.
# Users can uncomment the relevant sections if they want to project the raster to the properties of another NetCDF file.

############################################################################################################################################

# Load required libraries
library(raster)
library(ncdf4)
library(sf)

# Specify shapefile path
shp<-shapefile("/path/to/file/file.shp")

# Uncomment the following lines if you want to project to another NetCDF file
# -------------------------------------------------------------
# Reference NetCDF file for projection
# nc_file<-brick("/path/to/file/file.nc")
# e<-extent(...)
# nc_file<-crop(nc_file,e)
# -------------------------------------------------------------

# Set working directory
setwd("/path/to/folder/")

# List all NetCDF files in the directory
files<-list.files(pattern="*.nc")

# Loop through each NetCDF file
for( i in 1:length(files)){

# Extract the meaningful part of the file name for saving purposes
# The substring function is used to exclude the first 5 characters (assuming they are not needed) and the last 3 characters (assuming it's a file extension like '.nc').
# Adjust the indices based on your file naming conventions. 
fname<-substring(files[i], 6, nchar(files[i]) - 3) 

# Read the NetCDF file as a raster brick
brk<-brick(files[i])
brk<-crop(brk,e) # Crop the raster to the specified extent
brk<-mask(brk,shp) # Mask the raster using the shapefile

# Uncomment the following lines if you want to project to another NetCDF file
# -------------------------------------------------------------
# Project the raster to the reference NetCDF file
brk<-projectRaster(brk,nc_file)
# -------------------------------------------------------------

brk<-readAll(brk)  # Read all layers in the raster brick
save(brk,file=paste0("/path/to/folder/",fname,".grd"))  # Save the processed raster brick
}

