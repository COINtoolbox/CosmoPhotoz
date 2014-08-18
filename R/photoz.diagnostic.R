#  R package GRAD file R/photoz.diagnostic.R
#  Copyright (C) 2014  Rafael S. de Souza
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
#' @title Diagnostic for  photometric redshift fit
#' @param  photoz vector
#' @param specz  vector
#' @return list 
#'@examples
#'
#' y <- rgamma(100,10,.1)
#' summary(glm(y~1,family=Gamma))
#'  
#' @export 
#
# A list of summary statistics for  photo-z estimation

photoz.diagnostic <- function(photoz, specz){

  # First some basic error control
  if( ! is.vector(photoz) ) {
    stop("Error in photoz.diagnostic :: photoz is not a vector, and the code expects a vector.")
  }
  if( ! is.vectore(specz) ) {
    stop("Error in photoz.diagnostic :: specz is not a vector, and the code expects a vector.")
  }

  # Now, for the real work
  # Summarize results  
  Out <- 100*length(photoz[(abs(specz-photoz))>0.15*(1+specz)])/length(specz)
  
  # Calculate the necessary diagnostics
  photo.mean <- abs(mean((specz-photoz)/(1+specz)))      # mean  
  photo.sd <- sd((specz-photoz)/(1+specz))               # sd  
  photo.median <- abs(median((specz-photoz)/(1+specz)))  # median  
  photo.mad <- mad((specz-photoz)/(1+specz))             # mad  
  photo.rmse <- sqrt(mean((specz-photoz)^2))             # rmse
  photo.outliers <- paste(round(Out,2),"%",sep="")       # catastrophic errors
  
  return(list(mean=photo.mean,sd=photo.sd,median=photo.median,
              mad=photo.mad, rmse=photo.rmse,
              outliers=photo.outliers))
} 







