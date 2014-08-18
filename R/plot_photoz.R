#  R package GRAD file R/plot_photoz.R
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
#' @title Plot Predict photometric vs observed redshift from a GLM fit 
#' @import ggplot2 ggthemes
#' @param  photoz vector
#' @param  specz vector 
#' @return ggplot object  
#'@examples
#'
#' y <- rgamma(100,10,.1)
#' summary(glm(y~1,family=Gamma))
#'  
#' @export 
#
# A ggplot  object 

plot_photoz <- function(photoz, specz, type=c("errordist", "predobs", "errorviolins")) {
  
  # First some basic error control
  if( ! (type %in% c("errordist", "predobs", "errorviolins"))) {
    stop("Error in plot_photoz :: the chosen plot type is not implemented.")
  } 
  if( ! is.vector(photoz) ) {
    stop("Error in plot_photoz :: photoz is not a vector, and the code expects a vector.")
  }
  if( ! is.vector(specz) ) {
    stop("Error in plot_photoz :: specz is not a vector, and the code expects a vector.")
  }

  # Now, for the real work
  # If the user wants to plot the error distributions
  if(type=="errordist") {
    sig <- data.frame(sigma=(specz-photoz)/(1+specz))
    g1 <- ggplot(sig,x=sigma) + geom_density(aes(x=sigma),fill="cyan") + coord_cartesian(c(-1, 1)) +
      xlab(expression((z[phot]-z[spec])/(1+z[spec]))) +
      theme_economist_white(gray_bg = F, base_size = 11, base_family = "sans") +
      theme(plot.title = element_text(hjust=0.5),
          axis.title.y=element_text(vjust=0.75),
          axis.title.x=element_text(vjust=-0.25),
          text = element_text(size=20))
    return(g1)
  }

  # If the user wants to plot the predicted versus the reference values
  if(type=="predobs") {
    comb <- cbind(specz,photoz)
    colnames(comb) <- c("zspec","zphot")
    comb <- as.data.frame(comb)
    p1 <- ggplot(comb,aes(x=zspec,y=zphot))
    p2 <- p1 + stat_density2d(bins=200,geom="polygon",aes(fill =..level..,alpha=..level..),na.rm = TRUE,trans="log",n = 250,contour = TRUE) +
      coord_cartesian(c(0.3, 0.8), c(0.41, 0.71))+xlab(expression(z[spec]))+ylab(expression(z[phot])) +
      scale_fill_gradient2(guide="none",low = "red",mid="cyan",high = "blue2",space = "Lab") +
      geom_abline(intercept = 0)+theme(legend.text = element_text(colour="gray40"),legend.title=element_blank(),text = element_text(size=20),legend.position=c(0.1,0.75),axis.line = element_line(color = 'black')) +
      geom_density2d(colour="gray60",alpha=0.3, breaks = c(1, 5,10,25,50,100,200,250))+theme_gdocs() +
      scale_alpha(guide="none")
    return(p2)
  }

  # If the user wants to plot the error distribution as violin plots within predetermined bins
  if(type=="violins") {
    # VIOLIN CODE HERE
  }

}


