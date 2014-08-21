\name{CosmoPhotoz-package}
\alias{CosmoPhotoz-package}
\alias{CosmoPhotoz}
\docType{package}
\title{
Photometric redshift estimation based on Generalized Linear Models
}
\description{
This package provides user-friendly interfaces to perform fast and reliable photometric 
redshift estimation. The code make use generalized linear models and can adopt Gamma or 
Inverse Gaussian families, either from a frequentist or a bayesian perspective. The code
additionally provides a Shiny application providing a simple user interface.
}
\details{
\tabular{ll}{
Package: \tab CosmoPhotoz\cr
Type: \tab Package\cr
Version: \tab 0.1\cr
Date: \tab 2014-08-20\cr
License: \tab GPL (>= 3)\cr
}

The CosmoPhotoz package aims to provide a user-friendly interface to enable the estimation
of photometric redshifts. The present version employs Generalized Linear Models and the
user can adopt either Gamma or Inverse Gaussian families of links and follow either a 
frequentist or a bayesian perspective.

The package includes a plotting function to enable the production of diagnostic plots. Four examples of the visual diagnostics that are implemented can be seen in the figures bellow:

\if{html}{\figure{merged-Diag-Plots.jpg}{merged-Diag-Plots}}
\if{latex}{\figure{merged-Diag-Plots.pdf}{options: width=5.3in}}

Additionally, the code is also accompanied by a Shiny application that can be hosted
locally or deployed by the user at a webserver. This application allows the user to run the photometric redshift estimation and to configure many parameters of the code.

A short tutorial on how to use the package can be found at: 

ASDFASFASDFASDFADSFASDF


}
\author{
Rafael S. de Souza, Alberto Krone-Martins

Maintainer: Rafael S. de Souza <rafael.2706@gmail.com>
}
\references{
AAAAAAAAAAAAAAAAA DDDDDDDDD Here the reference to the submitted paper...
}
\keyword{ package }
\seealso{
  \code{\link{CosmoPhotoZestimator}}, 
  \code{\link{glmTrainPhotoZ}}, 
  \code{\link{glmPredictPhotoZ}}, 
  \code{\link{glm}}, 
	\code{\link{bayesglm}}
}
\examples{
\dontrun{
# Load the data
data(PHAT0train)
data(PHAT0test)
# Run the analysis
photoZest <- CosmoPhotoZestimator(PHAT0train, PHAT0test, 6)
# Create a boxplot showing the results
plotDiagPhotoZ(photoz = photoZest, specz = PHAT0test$redshift, type = "box")
}
}
