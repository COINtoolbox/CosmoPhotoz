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
#' @param  photoz data.frame
#' @param specz  data.frame 
#' @return data.frame 
#'@examples
#'
#' y <- rgamma(100,10,.1)
#' summary(glm(y~1,family=Gamma))
#'  
#' @export 
#
# A list of summary statistics for  photo-z estimation

photoz.diagnostic<-function(photoz,specz){
  # Summarize results
  
  Out<-100*length(photoz[(abs(specz-photoz))>0.15*(1+specz)])/length(specz)
  
  #Mean
  Photo.mean<-abs(mean((specz-photoz)/(1+specz)))
  #sd
  Photo.sd<-sd((specz-photoz)/(1+specz))
  #median
  Photo.median<-abs(median((specz-photoz)/(1+specz)))
  #mad
  Photo.mad<-mad((specz-photoz)/(1+specz))
  #rmse
  Photo.rmse<-sqrt(mean((specz-photoz)^2))
  #Catastrophic errors
  Photo.outliers<-paste(round(Out,2),"%",sep="")
  
  return(list(mean=Photo.mean,sd=Photo.sd,median=Photo.median,
              mad=Photo.mad, rmse=Photo.rmse,
              outliers=Photo.outliers        ))
} 
  










