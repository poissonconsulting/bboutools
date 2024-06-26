% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/priors.R
\name{bb_priors_recruitment}
\alias{bb_priors_recruitment}
\title{Recruitment model default priors}
\usage{
bb_priors_recruitment()
}
\value{
A named vector.
}
\description{
Prior distribution parameters and default values for recruitment model parameters.
}
\details{
Intercept

\code{b0 ~ Normal(mu = b0_mu, sd = b0_sd)}

Year Trend

\code{bYear ~ Normal(mu = bYear_mu, sd = bYear_sd)}

Year fixed effect

\code{bAnnual ~ Normal(mu = 0, sd = bAnnual_sd)}

Standard deviation of annual random effect

\code{sAnnual ~ Exponential(rate = sAnnual_rate)}

Adult female proportion

\code{adult_female_proportion ~ Beta(alpha = adult_female_proportion_alpha, beta = adult_female_proportion_beta)}
}
\examples{
bb_priors_survival()
}
