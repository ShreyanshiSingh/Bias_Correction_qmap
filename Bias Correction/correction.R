# This script performs monthly quantile mapping on gridded climate data, correcting current and future model values.
# Downloaded files are in .nc (NetCDF) format, a common format for climate data.
# The data undergoes preprocessing and is stored in brick format.
# The correction is done for each grid point to ensure proper adjustment, and results are saved for each month.
# The code utilizes the raster and qmap libraries in R.



##########################################################################################################################################

# Import necessary libraries
library(raster)
library(qmap)
#---------------------------------------------------------------------------------------------

# Define a vector containing the names of months for easy access
months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec") 

# Define vectors for the number of observations (n) and future values (n_ft).
# These vectors store counts relevant to your analysis, corresponding to each month.
# Adjust the values in each vector based on specific requirements.
# If the counts are constant across months, use singular values instead of vectors.

n<-c(...) 
n_ft<-c(...)

# Iterate through each month
for(i in 1:12){
# Load observed, model, and future model data for the current month
obs<-brick(paste0("/path/to/folder/",months[i],".grd"))
mod<-brick(paste0("/path/to/folder/",months[i],".grd"))
f_mod<-load(paste0("/path/to/folder/",months[i],".grd"))

# Define dimensions for corrected and future_corrected arrays
# Adjust the values of nrow and ncol based on your specific requirements.
nrow_val <- ...
ncol_val <- ...

# Create arrays for corrected and future_corrected values
corrected_array<-array(dim=c(nrow=nrow_val, ncol=ncol_val, nl=n[i]))     
future_corrected_array<-array(dim=c(nrow=nrow_val, ncol=ncol_val, nl=n_ft[i]))

# Apply quantile mapping for each grid point
for(x in 1:nrow_val){
  for(y in 1:ncol_val){
    observed<-t(as.array(obs[x,y,]))
    model<-t(as.array(mod[x,y,]))
    f_model<-t(as.array(f_mod[x,y,]))

    # Fit quantile mapping and apply to model and future model
    qm4.fit <- fitQmap(observed,model,
                       method="QUANT",qstep=0.01,na.rm=T)
                       
    qm4 <- doQmap(model,qm4.fit,type="linear",na.rm=T)
    qmf<-doQmap(f_model,qm4.fit,type="linear",na.rm=T)

    # Store the results in corrected and future_corrected arrays
    corrected_array[x,y,]<-qm4
    future_corrected_array[x,y,]<-qmf
  }
}
# Save the corrected and future_corrected arrays for the current month
save(corrected_array,file=paste0("/path/to/folder/",months[i],".RData"))
save(future_corrected_array,file=paste0("/path/to/folder/",months[i],".RData"))

}
# Main processing is complete. You can conclude the workflow at this point.

# If you wish to save the corrected array back as a brick, follow the steps below and remove the last curly brace.
# Ensure to adjust the file path as needed.
# Uncomment and customize the following lines to save the corrected array as a brick:


#------------------------------------------------------------------------------------------ 
# covert arrray back to brick format for furthur use
# raster_list <- list()
# nyears<- ny
# for(k in 1:ny){           
#  array2d <-corrected_array[,,k]           
#  ra<-raster(array2d)
       #-------------------------------------------------
  # follow these steps if crs is not present 
 # crs(ra)<-"..."
 # extent(ra)<-c(...)
  #-------------------------------------------------
  
#  raster_list[[k]] <- ra
# }
# brick_obj <- brick(raster_list)
# Bcorr_brick<-readAll(brick_obj)
# save(Bcorr_brick,file=paste0("/path/to/folder/",months[i],".grd"))

# Follow a similar process for the future_corrected arrays.

# }



