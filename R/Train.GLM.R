#  R package GRAD file R/TrainGLM.R
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
#' @title Fit a GLM function in the training set  
#' @param x  data.frame 
#' @return GLM object 
#' @import  arm COUNT 
#'@examples
#'
#' y <- rgamma(100,10,.1)
#' summary(glm(y~1,family=Gamma))
#'  
#' @export 
#
# A GLM fit for photo-z

TrainGLM <- function(x, method=c("Frequentist","Bayesian"), family=c("gamma","inverse.gaussian")) {

  # First some basic error control
  if( ! (method %in% c("Frequentist","Bayesian"))) {
    stop("Error in TrainGLM :: the chosen method is not implemented.")
  } 
  if( ! (family %in% c("gamma","inverse.gaussian"))) {
    stop("Error in TrainGLM :: the chosen family is not implemented.")
  } 
  if( ! is.data.frame(x) ) {
    stop("Error in TrainGLM :: x is not a data frame, and the code expects a data frame.")
  }

  # Now, for the real work
  ## Frequentist 
  if(method=="Frequentist"){
    if(family=="gamma"){
      GLM_data <- glm(redshift~., family=inverse.gaussian(link = "1/mu^2"), data=x)
    }
    if(family=="inverse.gaussian"){
      GLM_data <- glm(redshift~., family=gamma(link = "log"), data=x) 
    }
  }
  
  ## Bayesian
  if(method=="Bayesian"){    
    if(family=="gamma"){
      GLM_data <- bayesglm(redshift~., family=gamma(link="log"), data=x)
    }
    if(family=="inverse.gaussian"){
      GLM_data <- bayesglm(redshift~., family=inverse.gaussian(link = "1/mu^2"), data=x)
    }
  }

  # That's it folks!
  # return(summary(GLM_data))
  return(list(glmfit = GLM_data, Summary = summary(GLM_data),
              AICn = modelfit(GLM_data)$AICn,
              BICqh = modelfit(GLM_data)$BICqh))  
}

