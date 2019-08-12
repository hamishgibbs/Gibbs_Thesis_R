# Gibbs_Thesis_R

This repository contains code submitted as part of a University of Glasgow Master's Thesis Project in September 2019. 

The project abstract is as follows:

This research investigated the contribution of remote sensing data to monitor a number of grassland forage quantity and quality metrics measured with field observations in Colombia in the fall of 2018. The performance of different machine learning models was compared to that of standard multiple linear regression for predicting each metric. Satellite data generated by the Sentinel 1 and Sentinel 2 satellite constellations was used to calibrate predictive models. The contributions of different satellite derived variables for predicting forage conditions were quantified to understand the importance of different sensors to the overall predictive accuracy of each model.
	It was found that machine learning regression techniques greatly improved the predictive accuracy of forage metrics when compared to a standard multiple linear regression model. Despite this increase in accuracy, Median Absolute Error remained high and no forage metric was predicted with an R2 value greater than 0.70. Sentinel 1 data was found to make some contribution to the performance of predictive models as the importance of Sentinel 1 derived variables was noted for a number of forage metrics. Variable optimization (feature selection) was also conducted in an effort to improve predictive accuracy. The results of this variable optimization were mixed, improving the accuracy of some predictions while decreasing the accuracy of others. 
	After calibrating regression models for each forage metric, these models were applied outside of the study area to predict metrics across a 10 x 10 km area surrounding the research site. The results of this predictive modelling were compared to the original field observations and found to have similar distributions and central tendency to the original observations. This indicates that the models predicted vegetation conditions similar to those observed at the research plot during field sampling.

This code has not been used to create a python module and contains inconsistencies which will prevent its use for other applications without modifications. 

All generated code files are contained in this repository, including those that no longer function, and those that were not used during analysis in the final research product. 

Files are names in the format 'File__Version.r,' the most recent version will be the file with the highest number. For example, Data_Extract_2.r is more recent than Data_Extract_1.r.
