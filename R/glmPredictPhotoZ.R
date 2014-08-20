#  R package GRAD file R/glmPredictPhotoZ.R
#  Copyright (C) 2014  COIN
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License version 3 as published by
#the Free Software Foundation.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/
#

#' @title Predict photometric redshifts using a given a GLM fit object
#'
#' @description \code{computeDiagPhotoZ} computes a list of simple summary 
#' statistics for the photometric redshift estimation.
#' 
#' @param data a data.frame containing the data one wished to compute the redshift
#' @param train a trainned GLM object containing the fit of the model
#' @return list containing the results of the redshift estimation
#' @examples
#' \dontrun{
#' # First, generate some mock data
#' ppo <- runif(1000, min=0.1, max=2)
#' ppo_ph <- rnorm(length(ppo), mean=ppo, sd=0.05)
#'  
#' # Now, mock a redshift training and estimation
#' }
#
#' @usage glmPredictPhotoZ(data, train)
#' 
#' @author Rafael S. de Souza, Alberto Krone-Martins
#' 
#' @keywords utilities
#' @export
glmPredictPhotoZ <- function(data, train){
	
 	# First some basic error control
 	if( ! is.data.frame(data) ) {
 		stop("Error in glmPredictPhotoZ :: data is not a data frame, and the code expects a data frame.")
 	}
 	###### WE NEED TO CHECK IF THE train is a GLM object :: we need to verify if there is a simple way to perform this checking
 	
	# Now for the real work
	#Photoz<-predict(train,newdata=subset(data,select=-c(redshift)),type="response",se.fit = TRUE)
	photozObj <- predict(train, newdata=data, type="response", se.fit = TRUE)
	photoz <- photozObj$fit
	err_photoz <- photozObj$se.fit

	# That's all folks!
	return(list(photoz=photoz, err_photoz=err_photoz))
}


