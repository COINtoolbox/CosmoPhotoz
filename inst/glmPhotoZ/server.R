library(shiny)
library(CosmoPhotoz)

shinyServer(function(input, output) {

  # Now, we need to create the reactive container
  shinyCompPhotoZ <- reactive({
    # First we need to have some data, of course!
    inFile <- input$file1
    if (is.null(inFile)) {
      return(NULL)
    }

    ######
    ###### PRELIMINARY :: Data preparation only
    ######
    MegaZ <- read.table(file=inFile$datapath, header=TRUE)
    MegaZ.mag<-MegaZ[,c("mag_u","mag_g","mag_r","mag_i","mag_z","redshift")]
    
    set.seed(12378)
    test_index <- sample(seq_len(nrow(MegaZ.mag)), replace=F, size = floor(input$fracDataDiag * nrow(MegaZ.mag)))
    
    Mega.train <- as.data.frame(MegaZ.mag[-test_index, ]) # training set
    Mega.test <- as.data.frame(MegaZ.mag[test_index, ])   # testing set

    ######
    ###### THE ACTUAL CODE IS HERE
    ######
    PC_comb<-computeCombPCA(Mega.train[,-6],Mega.test[,-6])
    specz<-Mega.test$redshift

    # Principal componentes for training data
    trainpc<-cbind(PC_comb$x, Mega.train$redshift)
    colnames(trainpc)<-c("PC1", "PC2", "PC3", "PC4", "redshift")

    # Principal components for test data
    testpc<-PC_comb$y
    colnames(testpc)<-c("PC1", "PC2", "PC3", "PC4")

    # Here you train compute the glm model to predict photometric redshifts
    glmfit <- glmTrainPhotoZ(trainpc, method=input$method, family=input$family)

    # Here you predict your photometric redshift from your photometric data
    photoz <- glmPredictPhotoZ(data = testpc, train = glmfit$glmfit)$photoz

    # Time to return the data!
    return(data.frame(photoz, specz))
  })

  shinyCompPhotoZ_estimate <- reactive({
    # First we need to have some data, of course!
    inFile <- input$file2
    if (is.null(inFile)) {
      return("\n GLM PhotoZ Estimator :: No file was uploaded for redshift estimation! ")
    }

    #MegaZestimate <- read.table(file=inFile$datapath, header=TRUE)
    #MegaZestimate.test <- MegaZestimate[,c("mag_u","mag_g","mag_r","mag_i","mag_z","redshift")]


    # STILL NEED TO COMPUTE THE TEST DATA IN THE PC SPACE

    # TODO TODO TODO

    # Here you predict your photometric redshift from your photometric data
    #photozRes <- glmPredictPhotoZ(data = testpc, train = glmfit$glmfit)$photoz

    #return(photozRes)
  })

  # Create the output text
  output$diagnostics <- renderPrint({
    temp <- shinyCompPhotoZ()
    if(!is.null(temp)) {
      computeDiagPhotoZ(temp$photoz, temp$specz)
    }
  })

  # Create basic comparison plots
  output$errorDistPlot <- renderPlot({
    temp <- shinyCompPhotoZ()
    if(!is.null(temp)) {
      plotDiagPhotoZ(temp$photoz, temp$specz, type = "errordist")
    }
  })
  output$predictObs <- renderPlot({
    temp <- shinyCompPhotoZ()
    if(!is.null(temp)) {
      plotDiagPhotoZ(temp$photoz, temp$specz, type = "predobs")
    }
  })
  output$violins <- renderPlot({
    temp <- shinyCompPhotoZ()
    if(!is.null(temp)) {
      plotDiagPhotoZ(temp$photoz, temp$specz, type = "errorviolins")
    }
  })

  # Download the data
  output$downloadData <- downloadHandler(
    filename = function() { "glmPhotoZresults.dat" },
    content = function(file) {
      write.table(shinyCompPhotoZ_estimate(), file, quote=F, sep=" ", col.names = FALSE, row.names = FALSE)
    }
  )

})
