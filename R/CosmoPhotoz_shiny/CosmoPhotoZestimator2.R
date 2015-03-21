CosmoPhotoZestimator2 <- function(trainData, testData, numberOfPcs=4, method="Bayesian", family="gamma", robust=TRUE) {
  # Combine the training and test data and calculate the principal components
  redshift <- NULL # <- this is just to prevent a NOTE from CRAN checks
  PC_comb <- computeCombPCA(subset(trainData, select=c(-redshift)),
                            subset(testData,  select=c(-redshift)),
                            robust=robust)
  Trainpc <- cbind(PC_comb$x, redshift=trainData$redshift)
  Testpc <- PC_comb$y
  
  # Dynamic generation of the formula based on the user selected number of PCs
  formMa <- "poly(Comp.1,2)*poly(Comp.2,2)*"
  formMb <- paste(names(PC_comb$x[3:numberOfPcs]), collapse="*")
  formM <- paste("redshift~",formMa, formMb, sep="")
  
  # Fitting
  Fit <- glmTrainPhotoZ(Trainpc, formula=eval(parse(text=formM)), 
                        method=method, family=family)
  
  # Predict 
  
  # Photo-z estimation
  photoz_temp <- predict(Fit$glmfit, newdata=Testpc, type="link", se.fit = TRUE)
  photoz <- photoz_temp$fit
  # Error 
  critval <- 1.96 ## approx 95% CI
  upr <- photoz_temp$fit + (critval * photoz_temp$se.fit)
  lwr <- photoz_temp$fit - (critval * photoz_temp$se.fit)
  fit <-  photoz_temp$fit
  
  fit2 <- Fit$glmfit$family$linkinv(fit)
  upr2 <- Fit$glmfit$family$linkinv(upr)
  lwr2 <- Fit$glmfit$family$linkinv(lwr)
  errup<-upr2-fit2
  errlow<-fit2-lwr2

  return(list(photoz=round(fit2,4), errup_photoz=round(upr2,4),errlow_photoz=round(lwr2,4)))
}