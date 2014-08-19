#  R package GRAD file R/computeCombPCA.R
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
# A list of PCA projections for each matrix

computeCombPCA <- function(x, y, npcvar=4) {

  # First some basic error control
  if(!is.matrix(x)&!is.data.frame(x)) {
    stop("Error in computeCombPCA :: x is nor a matrix neither a data frame. The code expects a matrix or data frame.")
  }
  if(!is.matrix(y)&!is.data.frame(y)) {
    stop("Error in computeCombPCA :: y is nor a matrix neither a data frame. The code expects a matrix or data frame.")
  }
  
  # Now for the real work
  XY <- rbind(x, y)                                            # Create the combined matrix 
  XYPCA <- PCAgrid(XY, k=ncol(XY)-1,scale="mad",method="mad")  # Calculate the robust PCA
  X.PCA <- as.data.frame(XYPCA$scores[1:nrow(x),])             # get the scores in a data frame
  Y.PCA <- as.data.frame(XYPCA$scores[(nrow(x)+1):nrow(XY),])  # get the scores in a data frame
  PCvar <- which(cumsum((XYPCA$sdev)^2) / sum(XYPCA$sdev^2) >= npcvar)[1]
  
  # That's all folks!
  return(list(x=X.PCA, y=Y.PCA, PCvar=PCvar))
}

