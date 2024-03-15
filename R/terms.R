params_survival <- function() {
  c(
    "b0",
    "sAnnual",
    "sMonth",
    "bMonth",
    "bAnnual",
    "bYear"
  )
}

priors_survival <- function() {
  c(
    b0_mu = 4,
    b0_sd = 2,
    bYear_mu = 0,
    bYear_sd = 1,
    sAnnual_rate = 1,
    sMonth_rate = 1,
    bAnnual_sd = 1
  )
}

inits_survival <- function() {
  c(
    b0 = 4,
    sAnnual = 1,
    sMonth = 1,
    bYear = 0
  )
}

params_recruitment <- function() {
  c(
    "b0",
    "adult_female_proportion",
    "sAnnual",
    "bAnnual",
    "bYear"
  )
}

priors_recruitment <- function() {
  c(
    b0_mu = -1.4,
    b0_sd = 0.5,
    bYear_mu = 0,
    bYear_sd = 1,
    sAnnual_rate = 1,
    adult_female_proportion_alpha = 65,
    adult_female_proportion_beta = 35,
    bAnnual_sd = 1
  )
}

inits_recruitment <- function() {
  c(
    b0 = -1.4,
    sAnnual = 1,
    adult_female_proportion = 0.65,
    bYear = 0
  )
}

replace_priors <- function(priors, new_prior) {
  if (is.null(new_prior)) {
    return(priors)
  }
  replace(priors, names(new_prior), new_prior)
}
