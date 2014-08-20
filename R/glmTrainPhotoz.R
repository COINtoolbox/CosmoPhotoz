#  R package GRAD file R/glmTrainPhotoZ.R
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

#' @title Fit a GLM for photometric redshift estimation
#'
#' @description \code{glmTrainPhotoZ} trains a generalized linear model for 
#' photometric redshift estimation.
#' 
#' @import arm COUNT
#' @param x a data.frame containing the data to train the model
#' @param formula an object of class "formula" to be adopted
#' @param method a string containing the chosen GLM method. Two options are available: \code{Frequentist} will use the function  \code{\link{glm}} from the package \code{stats}; \code{Bayesian} will use the function \code{\link{bayesglm}} from the package  \code{arm}.
#' @param family a string containing \code{gamma} or \code{inverse.gaussian} (a description of the error distribution and link function to be used in the model).
#' @return a trainned GLM object containing the fit of the model
#' @examples
#' \dontrun{
#' # First, load the test and train data
#' packagePath <- paste(find.package("CosmoPhotoz"),"/extdata/",sep="")
#' trainData <- read.table(file=paste(packagePath, "sdss-ugriz-train.dat", sep=""), header=FALSE)
#' testData <-  read.table(file=paste(packagePath, "sdss-ugriz-test.dat", sep=""), header=FALSE)
#' trainData <- trainData[,c(1:5,11)] # Select the relevant data (photometry and spectroscopic redshift)
#' testData <- testData[,c(1:5,11)]   # Select the relevant data (photometry and spectroscopic redshift)
#' colnames(trainData) <- c("u", "g", "r", "i", "z", "redshift")
#' colnames(testData) <- c("u", "g", "r", "i", "z", "redshift")
#' 
#' # Combine the training and test data and calculate the principal components
#' PC_comb <- computeCombPCA(subset(trainData, select=c(-redshift)), subset(testData,  select=c(-redshift)))    
#' Trainpc <- cbind(PC_comb$x, redshift=testData$redshift)
#' Testpc <- PC_comb$y
#' 
#' # Dynamic generation of the formula based on the user selected number of PCs
#' nPcs <- 4 ## THE NUMBER OF PCS USED ENTER HERE
#' formM <- paste(names(PC_comb$x[1:nPcs]), collapse="*") 
#' formM <- paste("redshift~",formM, sep="")
#' 
#' # Fitting
#' Fit <- glmTrainPhotoZ(Trainpc, formula=eval(parse(text=formM)), method="Bayesian" , family="gamma")
#' 
#' # Photo-z estimation
#' photoz <- predict(Fit$glmfit, newdata=Testpc, type="response")
#' specz <- PHAT0test$redshift
#' }
#
#' @usage glmTrainPhotoZ(x, formula=NULL, method=c("Frequentist","Bayesian"), family=c("gamma","inverse.gaussian"))
#' 
#' @author Rafael S. de Souza, Alberto Krone-Martins
#' 
#' @keywords utilities
#' @export
glmTrainPhotoZ <- function(x, formula=NULL, method=c("Frequentist","Bayesian"), family=c("gamma","inverse.gaussian")) {

  # First some basic error control
  if( ! (method %in% c("Frequentist","Bayesian"))) {
    stop("Error in glmTrainPhotoZ :: the chosen method is not implemented.")
  } 

  if( ! (family %in% c("gamma","inverse.gaussian"))) {
    stop("Error in TrainGLM :: the chosen family is not implemented.")
  }

  if( ! is.data.frame(x) ) {
    stop("Error in glmTrainPhotoZ :: x is not a data frame, and the code expects a data frame.")
  }

  # Now, for the real work
  ## Frequentist 
  if(method=="Frequentist"){
    if(family=="gamma"){
      GLM_data <- glm(formula=formula, family=Gamma(link = "log"), data=x) 
    }
    if(family=="inverse.gaussian"){
      GLM_data <- glm(formula=formula, family=inverse.gaussian(link = "1/mu^2"), data=x)
    
    }
    
   
    
  }
  
  ## Bayesian
  if(method=="Bayesian"){    
    if(family=="gamma"){
      GLM_data <- bayesglm(formula=formula, family=Gamma(link="log"), data=x)
    }
    if(family=="inverse.gaussian"){
      GLM_data <- bayesglm(formula=formula, family=inverse.gaussian(link = "1/mu^2"), data=x)
    }
  }

  # That's it folks!
  # return(summary(GLM_data))
  return(list(glmfit = GLM_data, Summary = summary(GLM_data),
              AICn = modelfit(GLM_data)$AICn,
              BICqh = modelfit(GLM_data)$BICqh))  
}

