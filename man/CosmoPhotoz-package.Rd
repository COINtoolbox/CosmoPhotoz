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
~~ An overview of how to use the package, including the most important ~~
~~ functions ~~
}
\author{
Rafael S. de Souza, Alberto Krone-Martins

Maintainer: Rafael S. de Souza <rafael.2706@gmail.com>
}
\references{
~~ Literature or other references for background information ~~
}
\keyword{ package }
\seealso{
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
