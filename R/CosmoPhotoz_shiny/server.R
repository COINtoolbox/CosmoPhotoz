#  R package CosmoPhotoz file inst/glmPhotoZ-2/server.R
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

library(shiny)
require(CosmoPhotoz)
library(ggplot2)
library(ggthemes)
library(shinyIncubator)
source("CosmoPhotoZestimator2.R")
options(shiny.maxRequestSize=100*1024^2) # This is to change the maximum size of the upload to 30 MB

shinyServer(function(input, output) {

  # Now, we need to create the reactive container
  shinyCompPhotoZ <- reactive({
    # First we need to have some data, of course!
      if(input$dataSourceFlag == FALSE) {
        # First the file used for training
        inFile1 <- input$file1
        if (is.null(inFile1)) {
          return(NULL)
        }
        # Then the file used for estimating
        inFile2 <- input$file2
        if (is.null(inFile2)) {
          return(NULL)
          #return("\n GLM PhotoZ Estimator :: No file was uploaded for redshift estimation! ")
        }
        # Now read the files
        PHAT0train <- read.table(file=inFile1$datapath, sep=",", header=TRUE)
        PHAT0test <- read.table(file=inFile2$datapath, sep=",", header=TRUE)
      } else {
        # In this case, just lazy load the data from inside the package
        data(PHAT0train)
        data(PHAT0test)
      }
      
      # Some basic checking to make sure that the user will not enter values that could 
      # cause problems via the user interface.
      if(is.na(input$numberOfPcs)) {
        return(NULL)
      }
      if(is.na(input$numberOfPoints)) {
        return(NULL)
      }
      nPc <- input$numberOfPcs
      if (nPc > (ncol(PHAT0train)-1)) {
        nPc <- (ncol(PHAT0train)-1)
      } 
      if (nPc <= 0) {
        return(NULL)
      }
      if (input$numberOfPoints <= 0) {
        return(NULL)
      }

      # Photo-z estimation
      photoz <- CosmoPhotoZestimator2(trainData=PHAT0train, testData=PHAT0test, 
                                     numberOfPcs=nPc, method=input$method,
                                     family=input$family, robust=input$useRobustPCA)

      if("redshift" %in% names(PHAT0test)) {
        specz <- PHAT0test$redshift
      } else {
        specz <- NULL
      }

    # Time to return the data!
    return(data.frame(photoz=photoz$photoz, errup_photoz= photoz$errup_photoz,errlow_photoz= photoz$errlow_photoz,
                      specz))
  })

  # Create the output text
  output$diagnostics <- renderPrint({
    tempObj <- shinyCompPhotoZ()
    if(!is.null(tempObj)) {
      computeDiagPhotoZ(tempObj$photoz, tempObj$specz)
    }
  })

  # Create basic comparison plots
  output$errorDistPlot <- renderPlot({
    tempObj <- shinyCompPhotoZ()
    if(!is.null(tempObj)) {
      plotDiagPhotoZ(tempObj$photoz, tempObj$specz, type = "errordist")
    }
  })
  output$predictObs <- renderPlot({
    tempObj <- shinyCompPhotoZ()
    if(!is.null(tempObj)) {

      nPointsToUse <- input$numberOfPoints
      
      if(nPointsToUse > length(tempObj$specz)){
        nPointsToUse <- length(tempObj$specz)
      }
      
      plotDiagPhotoZ(tempObj$photoz, tempObj$specz, type = "predobs", npoints=nPointsToUse)
    }
  })
  output$violins <- renderPlot({
    tempObj <- shinyCompPhotoZ()
    if(!is.null(tempObj)) {
      plotDiagPhotoZ(tempObj$photoz, tempObj$specz, type = "errorviolins")
    }
  })
  output$box <- renderPlot({
    tempObj <- shinyCompPhotoZ()
    if(!is.null(tempObj)) {
      plotDiagPhotoZ(tempObj$photoz, tempObj$specz, type = "box")
    }
  })

  # Download the data
  output$downloadData <- downloadHandler(
    filename = function() { "glmPhotoZresults.dat" },
    content = function(file) {
      tempObj <- shinyCompPhotoZ()
      if(!is.null(tempObj)) {
        photozObs<-data.frame(photoz=tempObj$photoz,errup_photoz=tempObj$errup_photoz,
                              errlow_photoz=tempObj$errlow_photoz)
        write.table(photozObs, file, quote=F, sep=" ", row.names = FALSE)
      } 
    }
  )
# Display results
photozObs<-reactive({
  tempObj <- shinyCompPhotoZ()
  if(!is.null(tempObj)) {
    photozObs<-data.frame(specz=tempObj$specz,photoz=tempObj$photoz,photoz_up=tempObj$errup_photoz,
                          photoz_down=tempObj$errlow_photoz)
    
  } 
})

  output$photoz_out<-renderDataTable(
    photozObs()
    )

})
