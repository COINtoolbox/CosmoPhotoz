#  R package GRAD file R/Predict.redshift.R
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
#' @title Predict photometric redshift from a GLM fit 
#' @param  x data.frame
#' @param train  GLM object 
#' @return data.frame 
#'@examples
#'
#' y <- rgamma(100,10,.1)
#' summary(glm(y~1,family=Gamma))
#'  
#' @export 
#
# A GLM fit for photo-z

Predict.redshift<-function(data=x,train=train){

#Photoz<-predict(train,newdata=subset(data,select=-c(redshift)),type="response",se.fit = TRUE)
  Photoz<-predict(train,newdata=data,type="response",se.fit = TRUE)
  photoz<-Photoz$fit
  err_photoz<-Photoz$se.fit
return(list(photoz=photoz,err_photoz=err_photoz))
}


