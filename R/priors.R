priors_survival <- function(){
  c(
    b0_mu = 3,
    b0_sd = 10,
    bYear_mu = 0,
    bYear_sd = 2,
    bAnnual_sd = 10,
    sAnnual_rate = 1,
    sMonth_rate = 1
  )
}

priors_recruitment <- function(){
  c(
    b0_mu = -1.5,
    b0_sd = 0.5,
    bYear_mu = 0,
    bYear_sd = 2,
    bAnnual_sd = 1,
    sAnnual_rate = 1,
    adult_female_proportion_alpha = 65,
    adult_female_proportion_beta = 35
  )
}

#' Survival model default priors
#' 
#' Prior distribution parameters and default values for survival model parameters. 
#' 
#' Intercept
#' 
#' `b0 ~ Normal(mu = b0_mu, sd = b0_sd)`
#' 
#' Year Trend
#' 
#' `bYear ~ Normal(mu = bYear_mu, sd = bYear_sd)`
#' 
#' Year fixed effect
#' 
#' `bAnnual ~ Normal(mu = 0, sd = bAnnual_sd)`
#' 
#' Standard deviation of annual random effect
#' 
#' `sAnnual ~ Exponential(rate = sAnnual_rate)`
#' 
#' Standard deviation of month random effect
#' 
#' `sMonth ~ Exponential(rate = sMonth_rate)`
#' 
#' @return A named vector. 
#' @export
#'
#' @examples bb_priors_survival()
bb_priors_survival <- function() {
  priors_survival()
}

#' Recruitment model default priors
#' 
#' Prior distribution parameters and default values for recruitment model parameters. 
#' 
#' Intercept
#' 
#' `b0 ~ Normal(mu = b0_mu, sd = b0_sd)`
#' 
#' Year Trend
#' 
#' `bYear ~ Normal(mu = bYear_mu, sd = bYear_sd)`
#' 
#' Year fixed effect
#' 
#' `bAnnual ~ Normal(mu = 0, sd = bAnnual_sd)`
#' 
#' Standard deviation of annual random effect
#' 
#' `sAnnual ~ Exponential(rate = sAnnual_rate)`
#' 
#' Adult female proportion
#' 
#' `adult_female_proportion ~ Beta(alpha = adult_female_proportion_alpha, beta = adult_female_proportion_beta)`
#' 
#' @return A named vector. 
#' @export
#'
#' @examples bb_priors_survival()
bb_priors_recruitment <- function() {
  priors_recruitment()
}