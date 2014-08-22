
Welcome to the CosmoPhotoz - GLM PhotoZ estimation Shiny interface! 

This interface provides a simple control for the R version of the CosmoPhotoz code. Beyond offering the control of the most used functionalities of the code, this interface provides graphical overviews of the results for diagnostics of the method (each tab is a different graphical representation of the analysis result).

#### Data Input

It is possible to select two types of data for analysis: 
* either the internal PHAT0 dataset (Hildebrandt et al. 2010);
* or you can upload your own data. 

Note that uploaded data must be a pure text file, with each entry separated by a comma (,) and containing a header. It may contain an arbitrary number of photometric bands (the column names are not important) and one column named `redshift`. This `redshift` column is mandatory for the training data, but it is not mandatory for the data used to estimate the redshift (in case it is not provided, however, no plots will be produced, but you can still download the resulting photometric redshift estimation).

Example of a file with photometric data from SDSS and spectroscopic redshifts:

```{r}
dered_u,dered_g,dered_r,dered_i,dered_z,redshift
20.30279,18.00114,16.80232,16.3375,15.99679,0.1606594
21.42244,20.27178,18.7326,18.13726,17.82471,0.2577918
22.47656,21.32556,20.38654,19.55709,19.20674,0.6040326
18.89463,17.87326,17.23221,16.89447,16.6657,0.1681648
...
```

#### Controls and options

The user can select if robust PCA should be used or not. Note that the adoption of robust PCA can slow down the code considerably. The user can also select the number of principal components to consider in the GLM analysis.

The number of points used for the creation of the predicted versus observed diagnostic plot (at the Prediction tab) can also be selected by the user for speeding up the plot generation. The default value (0) is to consider all the points in the test dataset. This value must be setted **before** launching the analysis.

The method adopted for the fitting can be selected among a frequentist approach (using the R function `glm`) and a bayesian approach (using the R function `bayesglm`). The link function to be used in the model can also be selected among the gamma function and the inverse gaussian function.

To run the photometric redshift estimate, the user must click in the "Run estimation" blue button. And after the estimate is ready, the redshifts can be downloaded to the user machine by clicking in the "Download photoZ results" button. 

