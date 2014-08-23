\name{CosmoPhotoz-package}
\alias{CosmoPhotoz-package}
\alias{CosmoPhotoz}
\docType{package}
\title{
Photometric redshift estimation based on Generalized Linear Models
}
\description{
This package provides an user-friendly interfaces to perform fast and reliable photometric 
redshift estimation. The code makes use of generalized linear models and can adopt Gamma or 
Inverse Gaussian families, either from a frequentist or a bayesian perspective. The code
additionally provides a Shiny application providing a simple user interface.
}
\details{
\tabular{ll}{
Package: \tab CosmoPhotoz\cr
Type: \tab Package\cr
Version: \tab 0.1\cr
Date: \tab 2014-08-22\cr
License: \tab GPL (>= 3)\cr
}

The CosmoPhotoz package aims to provide an user-friendly interface to enable the estimation
of photometric redshifts. The present version employs Generalized Linear Models and the
user can adopt either Gamma or Inverse Gaussian families of links and apply either a 
frequentist or a bayesian perspective at the fitting step.

The package includes a plotting function to enable the production of diagnostic plots. Four examples of the visual diagnostics that are implemented can be seen in the figures bellow:

\if{html}{\figure{merged-Diag-Plots.jpg}{merged-Diag-Plots}}
\if{latex}{\figure{merged-Diag-Plots.pdf}{options: width=5.3in}}

Additionally, the code is also accompanied by a \pkg{shiny} application that can be hosted locally or deployed by the user at a webserver. This application allows the user to run the photometric redshift estimation, to configure many parameters of the code visually and experiment with the results. It also allows the user to either use the PHAT0 data, or to upload its own data files (the expected format can be found at the application's help tab). A screenshot of this application can be seen in the next figure.

\if{html}{\figure{CosmoPhotoz-Shiny.jpg}{CosmoPhotoz-Shiny-Plots}}
\if{latex}{\figure{CosmoPhotoz-Shiny.pdf}{options: width=5.3in}}

To run the graphical interface locally, it is sufficient to call: 

\code{runApp(paste(find.package("CosmoPhotoz"),"/glmPhotoZ-2/",sep=""))}

Finally, a short tutorial on how to use the package can be found at: 

--------------- http://rafaelsdesouza.github.io/CosmoPhotoz/ -----------------

}
\author{
Rafael S. de Souza, Alberto Krone-Martins, Jonathan Elliott, Joseph Hilbe

Maintainer: Rafael S. de Souza <rafael.2706@gmail.com>
}
\references{
J. Elliott, R. S. de Souza, J. Hilbe, A. Krone-Martins, E. E. O. Ishida, E. Cameron, The Overlooked Potential of Generalized Linear Models in Astronomy-II: Photometric redshift, to be submitted to Astronomy & Computing (arXiv::.....).
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
# This is considerably faster, but the results are not so good
# photoZest <- CosmoPhotoZestimator(PHAT0train, PHAT0test, 6, robust=FALSE) 
# Create a boxplot showing the results
plotDiagPhotoZ(photoz = photoZest, specz = PHAT0test$redshift, type = "box")
}
}
