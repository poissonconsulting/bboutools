% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/augment.R
\name{augment.bboufit}
\alias{augment.bboufit}
\title{Get Augmented Data from bboufit Object}
\usage{
\method{augment}{bboufit}(x, ...)
}
\arguments{
\item{x}{The object.}

\item{...}{Unused parameters.}
}
\value{
A tibble of the augmented data.
}
\description{
Get a tibble of the original data with augmentation.
}
\examples{
if (interactive()) {
  fit <- bb_fit_survival(bboudata::bbousurv_a)
  augment(fit)
}
}
\seealso{
Other generics: 
\code{\link{augment.bboufit_ml}()},
\code{\link{glance.bboufit}()},
\code{\link{glance.bboufit_ml}()},
\code{\link{tidy.bboufit}()},
\code{\link{tidy.bboufit_ml}()}
}
\concept{generics}
