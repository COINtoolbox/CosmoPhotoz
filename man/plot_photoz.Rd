\name{plot_photoz}
\alias{plot_photoz}
\title{Plot Predict photometric vs observed  redshift from a GLM fit}
\usage{
plot_photoz(photoz, specz, type = c("errordist", "predobs"))
}
\arguments{
\item{photoz}{data.frame}

\item{specz}{data.frame}
}
\value{
ggplot object
}
\description{
A function to create diagnostics plots from the results of photometric redshifts.
}
\examples{
y <- rgamma(100,10,.1)
summary(glm(y~1,family=Gamma))
}

