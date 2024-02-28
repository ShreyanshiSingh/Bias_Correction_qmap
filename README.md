This repository provides R code for **gridwise bias correction** of climate models using the qmap package. The aim of the code is to correct biases in model values using observed values of the same time period. 
Additionally, the code applies the same bias correction to future values, assuming same biases persist. 

Article Reference: Under Review

## Methodology
The approach leverages the non-parametric quantile mapping method, specifically the 'fitQmapQUANT' function, which utilizes empirical quantiles for the bias correction process. 
Detailed information on qmap package and its methodology can be found [here](https://cran.r-project.org/web/packages/qmap/index.html).



## Workflow Overview
### Inputs:
1. *Model values* (historic and future)
2. *observed values*

It's crucial to ensure that both inputs share the same grid/resolution and cover identical time periods to facilitate accurate bias correction.

### Outputs:
1. *Historic Model Values with Bias Correction:* Refined model values with adjustments for biases.
2. *Future Model Values with Assumed Bias Correction:* Projected model values considering the persistence of existing biases.



Note: This repository is currently under development, and improvements are welcomed. Stay tuned for updates!
