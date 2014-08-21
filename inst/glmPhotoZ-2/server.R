library(shiny)
library(CosmoPhotoz)
library(ggplot2)
library(ggthemes)
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
      
      # Photo-z estimation
      photoz <- CosmoPhotoZestimator(trainData=PHAT0train, testData=PHAT0test, 
                                     numberOfPcs=input$numberOfPcs, method=input$method,
                                     family=input$family, robust=input$useRobustPCA)
      specz <- PHAT0test$redshift

    # Time to return the data!
    return(data.frame(photoz, specz))
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
      plotDiagPhotoZ(tempObj$photoz, tempObj$specz, type = "predobs", npoints=input$numberOfPoints)
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
        write.table(tempObj$photoz, file, quote=F, sep=" ", col.names = FALSE, row.names = FALSE)
      } 
    }
  )

})
