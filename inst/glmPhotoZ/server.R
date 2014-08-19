library(shiny)
library(CosmoPhotoz)
options(shiny.maxRequestSize=30*1024^2) # This is to change the maximum size of the upload to 30 MB

shinyServer(function(input, output) {

  # Now, we need to create the reactive container
  shinyCompPhotoZ <- reactive({
    # First we need to have some data, of course!

    if(input$dataSourceFlag == FALSE) {
      # Read and parse the file
      inFile <- input$file1
      if (is.null(inFile)) {
        return(NULL)
      }
      MegaZ <- read.table(file=inFile$datapath, header=TRUE)
      MegaZ.mag<-MegaZ[,c("mag_u","mag_g","mag_r","mag_i","mag_z","redshift")]

      ######
      ###### PRELIMINARY :: Data preparation only
      ######
      set.seed(12378)
      test_index <- sample(seq_len(nrow(MegaZ.mag)), replace=F, size = floor(input$fracDataDiag * nrow(MegaZ.mag)))
      Mega.train <- as.data.frame(MegaZ.mag[-test_index, ]) # training set
      Mega.test <- as.data.frame(MegaZ.mag[test_index, ])   # testing set

      ######
      ###### THE ACTUAL CODE IS HERE
      ######
      PC_comb<-computeCombPCA(Mega.train[,-6],Mega.test[,-6], npcvar=0.995)
      specz<-Mega.test$redshift

      # Principal componentes for training data
      trainpc<-cbind(PC_comb$x, redshift=Mega.train$redshift)

      # Principal components for test data
      testpc<-PC_comb$y

      # Here you train compute the glm model to predict photometric redshifts
#      glmfit <- glmTrainPhotoZ(trainpc, formula=eval(parse(text="redshift~Comp.1*Comp.2*Comp.3*Comp.4")), method=input$method, family=input$family)
#      glmfit <- glmTrainPhotoZ(trainpc, formula=redshift~Comp.1*Comp.2*Comp.3*Comp.4, method=input$method, family=input$family)
#      glmfit <- glmTrainPhotoZ(trainpc, formula=redshift~Comp.1*Comp.2*Comp.3*Comp.4, method="Frequentist", family = "gamma")
  #    formM <- paste(names(PC_comb$x), collapse="*")
 #     formM <- paste("redshift~",formM, sep="")
#      glmfit <- glmTrainPhotoZ(trainpc, formula=eval(parse(text=formM)), method="Frequentist", family = "gamma")

      # Dynamic generation of the formula based on the user selected number of PCs
      formM <- paste(names(PC_comb$x[1:4]), collapse="*") ## THE NUMBER OF PCS USED ENTER HERE
      formM <- paste("redshift~",formM, sep="")
      # Fitting
      Fit<-glmTrainPhotoZ(Trainpc, formula=eval(parse(text=formM)), method=input$method, family=input$family)

      # Here you predict your photometric redshift from your photometric data
      photoz <- glmPredictPhotoZ(data = testpc, train = glmfit$glmfit)$photoz
    } else {
      data(PHAT0train)
      data(PHAT0test)
      PC_comb<-computeCombPCA(subset(PHAT0train, select=c(-redshift)),
                              subset(PHAT0test,  select=c(-redshift)),
                              npcvar=0.995)    
      Trainpc<-cbind(PC_comb$x, redshift=PHAT0train$redshift)
      Testpc<-PC_comb$y
      # Dynamic generation of the formula based on the user selected number of PCs
      formM <- paste(names(PC_comb$x[1:6]), collapse="*") ## THE NUMBER OF PCS USED ENTER HERE
      formM <- paste("redshift~",formM, sep="")
      # Fitting
      Fit<-glmTrainPhotoZ(Trainpc, formula=eval(parse(text=formM)), method=input$method, family=input$family)
      # Photo-z estimation
      photoz<-predict(Fit$glmfit, newdata=Testpc, type="response")
      specz<-PHAT0test$redshift
    }


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
