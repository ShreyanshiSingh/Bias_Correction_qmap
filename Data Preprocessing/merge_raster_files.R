# This R script aims to merge multiple raster files into a single raster brick and then save the merged raster brick as a new file.
# The code assumes that the working directory is set to the folder containing the raster files stored in .grd format.
# It is useful when working with datasets containing raster bricks where each layer is associated with a distinct date. The script merges these files
# into a single raster brick, arranging the layers based on their date representation.

##########################################################################################################################################3


# Load the 'raster' library for raster data manipulation
library(raster)

# Set the working directory to the folder containing raster files
setwd("/path/to/files/")

# List all files in the directory that have the ".grd" extension
raster_files <- list.files(pattern = ".grd")

# Create an empty raster brick to store the merged raster layers
raster_brick <- brick()

# Loop through each raster file, loading it and adding it as a layer to the raster brick
for (i in 1:length(raster_files)) {
  current_raster <- load(raster_files[i])  # Load the current raster file
  raster_brick <- addLayer(raster_brick, current_raster)  # Add the loaded raster as a layer to the raster brick
}

# Order the layers in the raster brick based on their names
b <- raster_brick[[order(names(raster_brick))]]

# Read all layers in the ordered raster brick
merged_brick <- readAll(b)

# Save the merged raster brick as a new file
save(merged_brick, file = "/path/to/file/file.grd")
