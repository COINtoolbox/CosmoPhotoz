#  R package GRAD file R/CombPCA.R
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
#' @title Combined PCA for training and test sample 
#' @param x matrix or data.frame 
#' @param y matrix or data.frame 
#' @return PCA projections for each matrix 
#' @import  pcaPP
#'@examples
#'
#' Multivariate data with outliers
#' library(mvtnorm)
#' x <- rbind(rmvnorm(100, rep(0, 6), diag(c(5, rep(1,5)))),
#'           rmvnorm( 15, c(0, rep(20, 5)), diag(rep(1, 6))))
#' y <- rbind(rmvnorm(100, rep(0, 6), diag(c(5, rep(1,5)))),
#'           rmvnorm( 15, c(0, rep(20, 5)), diag(rep(1, 6))))         
# Here we calculate the principal components with PCAgrid
#'pc <- PCAgrid(x) 
#'  
#' @export 
#
# A list of PCA projection for each matrix

CombPCA<-function(x,y){
  
  if(!is.matrix(x)&!is.data.frame(x))
    stop("Need a matrix or data frame!")
  XY<-rbind(x,y) # Combined matrix 
  XYPCA<- PCAgrid(XY,k=ncol(XY)-1,scale="mad",method="mad")
  X.PCA<-as.data.frame(XYPCA$scores[1:nrow(x),])
  Y.PCA<-as.data.frame(XYPCA$scores[(nrow(x)+1):nrow(XY),])
  return(list(x=X.PCA,y=Y.PCA))
}

