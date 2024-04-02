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
