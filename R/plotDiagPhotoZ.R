#  R package GRAD file R/plotDiagPhotoZ.R
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
#'@param  type list 
#' @return ggplot object  
#'@examples
#'
#' y <- rgamma(100,10,.1)
#' summary(glm(y~1,family=Gamma))
#'  
#' @export 
#
# A ggplot  object 

plotDiagPhotoZ <- function(photoz, specz, type=c("errordist", "predobs", "errorviolins","box")) {
  
  # First some basic error control
  if( ! (type %in% c("errordist", "predobs", "errorviolins","box"))) {
    stop("Error in plotDiagPhotoZ :: the chosen plot type is not implemented.")
  } 
  if( ! is.vector(photoz) ) {
    stop("Error in plotDiagPhotoZ :: photoz is not a vector, and the code expects a vector.")
  }
  if( ! is.vector(specz) ) {
    stop("Error in plotDiagPhotoZ :: specz is not a vector, and the code expects a vector.")
  }

  # Now, for the real work
  # If the user wants to plot the error distributions
  if(type=="errordist") {
    sig <- data.frame(sigma=(photoz-specz)/(1+specz))
    g1 <- ggplot(sig,x=sigma) + geom_density(aes(x=sigma),fill="blue2", alpha=0.4) + coord_cartesian(c(-1, 1)) +
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
      coord_cartesian(c(min(specz), max(specz)), c(min(photoz), max(photoz)))+xlab(expression(z[spec]))+ylab(expression(z[phot])) +
      scale_fill_gradient2(guide="none",low = "blue", mid="cyan", high = "orange2",space = "rgb") +
      geom_abline(intercept = 0)+theme(legend.text = element_text(colour="gray40"), legend.title=element_blank(), text = element_text(size=20),legend.position=c(0.1,0.75),axis.line = element_line(color = 'black')) +
      geom_density2d(colour="gray60", alpha=0.3, breaks = c(1, 5,10,25,50,100,200,250))+theme_gdocs() +
      scale_alpha(guide="none")
#      scale_fill_gradient2(guide="none",low = "red",mid="cyan",high = "blue2", space = "Lab") 
    return(p2)
  }

  # If the user wants to plot the error distribution as violin plots within predetermined bins
  if(type=="errorviolins") {
    # Load the file
    b2 <- factor(floor(specz * 10)/10)
    error_photoZ <- (specz-photoz)/(1+specz)
    dfd <- data.frame(z_photo=error_photoZ, z_spec=b2)  
    p <- ggplot(dfd) + xlab(expression(z[spec])) + ylab(expression((z[photo]-z[spec])/(1+z[spec]))) + ylim(-0.5, 0.5)
    p <- p + theme(legend.position = "none", axis.title.x = element_text(size=15), axis.title.y = element_text(size=15))
    p <- p + geom_violin(aes(z_spec, z_photo), fill=rgb(140/255,150/255,198/255), alpha=0.8)+
      theme_economist_white(gray_bg = F, base_size = 11, base_family = "sans") +
      theme(plot.title = element_text(hjust=0.5),
            axis.title.y=element_text(vjust=0.75),
            axis.title.x=element_text(vjust=-0.25),
            text = element_text(size=20))
  
    # hist_right <- ggplot(dfd) + geom_histogram(aes(z_photo), fill="dark magenta", alpha=0.4, binwidth=.001) + xlim(-0.5, 0.5)
    # hist_right <- hist_right + coord_flip() + theme(legend.position = "none",
    #    axis.title.y = element_blank(), axis.text.y = element_blank(), axis.title.y = element_text(size=15)) + ylab(bquote(paste("count (x",10^3,")") ))+ scale_y_continuous(breaks=c(0,5000,10000,15000), labels=c(0, 5, 10, 15))
    # hist_right <- hist_right + theme(plot.margin = unit(c(1, 1, 0.6, -0.5), "lines"))
  
    return(p)
    }

if(type=="box") {
  # Load the file
  b2 <- factor(floor(specz * 10)/10)
  error_photoZ <- (specz-photoz)/(1+specz)
  dfd <- data.frame(z_photo=error_photoZ, z_spec=b2)  
  p <- ggplot(dfd) + xlab(expression(z[spec])) + ylab(expression((z[photo]-z[spec])/(1+z[spec]))) + ylim(-0.5, 0.5)
  p <- p + theme(legend.position = "none", axis.title.x = element_text(size=15), axis.title.y = element_text(size=15))
  p <- p + geom_boxplot(aes(z_spec, z_photo), notch=F,fill="blue", alpha=0.8)+
    theme_economist_white(gray_bg = F, base_size = 11, base_family = "sans") +
    theme(plot.title = element_text(hjust=0.5),
          axis.title.y=element_text(vjust=0.75),
          axis.title.x=element_text(vjust=-0.25),
          text = element_text(size=20))
  
  # hist_right <- ggplot(dfd) + geom_histogram(aes(z_photo), fill="dark magenta", alpha=0.4, binwidth=.001) + xlim(-0.5, 0.5)
  # hist_right <- hist_right + coord_flip() + theme(legend.position = "none",
  #    axis.title.y = element_blank(), axis.text.y = element_blank(), axis.title.y = element_text(size=15)) + ylab(bquote(paste("count (x",10^3,")") ))+ scale_y_continuous(breaks=c(0,5000,10000,15000), labels=c(0, 5, 10, 15))
  # hist_right <- hist_right + theme(plot.margin = unit(c(1, 1, 0.6, -0.5), "lines"))
  
  return(p)
}
}


