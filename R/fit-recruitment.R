#' Fit Recruitment Model
#'
#' Fit heirarchical Bayesian recruitment model using Nimble.
#'
#' If the number of years is > `min_random_year`, a fixed-effects model is fit.
#' Otherwise, a mixed-effects model is fit with random intercept for each year.
#' If `year_trend` is TRUE and the number of years is > `min_random_year`, the model
#' will be fit with year as a continuous effect (i.e. trend) and no fixed effect of year.
#' If `year_trend` is TRUE and the number of years is <= `min_random_year`, the model
#' will be fit with year as a continuous effect and a random intercept for each year.
#'
#' The start month of the Caribou year can be adjusted with `year_start`.
#'
#' @inheritParams params
#' @return A list of the Nimble model object, data and mcmcr samples.
#' @export
#' @family model
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_recruitment(bboudata::bbourecruit_a)
#' }
bb_fit_recruitment <- function(
    data,
    adult_female_proportion = 0.65,
    yearling_female_proportion = 0.5,
    min_random_year = 5,
    year_trend = FALSE,
    year_start = 4L,
    nthin = 10,
    niters = 1000,
    priors = NULL,
    quiet = FALSE) {
  chk_data(data)
  bbd_chk_data_recruitment(data)
  chk_null_or(adult_female_proportion, vld = vld_range)
  chk_range(yearling_female_proportion)
  chk_whole_number(min_random_year)
  chk_gte(min_random_year)
  chk_flag(year_trend)
  chk_whole_number(year_start)
  chk_range(year_start, c(1, 12))
  chk_whole_number(nthin)
  chk_gt(nthin)
  chk_whole_number(niters)
  chk_gt(niters)
  default_priors <- priors_recruitment()
  .chk_priors(priors, names(default_priors))
  chk_flag(quiet)

  priors <- replace_priors(default_priors, priors)
  data <- model_data_recruitment(data, year_start = year_start, quiet = quiet)
  year_random <- data$datal$nAnnual >= min_random_year
  if (!year_random && year_trend) {
    message_trend_fixed()
  }

  model <- model_recruitment(
    data = data$datal,
    year_random = year_random,
    year_trend = year_trend,
    adult_female_proportion = adult_female_proportion,
    yearling_female_proportion = yearling_female_proportion,
    demographic_stochasticity = TRUE,
    priors = priors
  )

  vars <- model$getVarNames()
  params <- params_recruitment()
  monitor <- params[params %in% vars]
  if (!is.null(adult_female_proportion)) {
    monitor <- monitor[monitor != "adult_female_proportion"]
  }

  fit <- run_nimble(
    model = model, monitor = monitor,
    inits = NULL, niters = niters, nchains = 3L,
    nthin = nthin, quiet = quiet
  )

  attrs <- list(
    nthin = nthin,
    niters = niters,
    nobs = nrow(data$data),
    year_trend = year_trend
  )

  .attrs_bboufit(fit) <- attrs
  fit$data <- data$data
  fit$model_code <- model$getCode()
  class(fit) <- c("bboufit_recruitment", "bboufit")
  fit
}

#' Fit Recruitment Model with Maximum Likelihood
#'
#' Fit recruitment model with Maximum Likelihood using Nimble Laplace Approximation.
#'
#' If the number of years is > `min_random_year`, a fixed-effects model is fit.
#' Otherwise, a mixed-effects model is fit with random intercept for each year.
#' If `year_trend` is TRUE and the number of years is > `min_random_year`, the model
#' will be fit with year as a continuous effect (i.e. trend) and no fixed effect of year.
#' If `year_trend` is TRUE and the number of years is <= `min_random_year`, the model
#' will be fit with year as a continuous effect and a random intercept for each year.
#'
#' Year effect can be excluded with `exclude_year`. This can be useful if the ML model is failing to converge.
#'
#' The start month of the Caribou year can be adjusted with `year_start`.
#'
#' @inheritParams params
#' @return A list of the Nimble model object and Maximum Likelihood output with estimates and standard errors on the transformed scale.
#' @export
#' @family model
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_recruitment_ml(bboudata::bbourecruit_a)
#' }
bb_fit_recruitment_ml <- function(
    data,
    adult_female_proportion = 0.65,
    yearling_female_proportion = 0.5,
    min_random_year = 5,
    year_trend = FALSE,
    year_start = 4L,
    inits = NULL,
    quiet = FALSE) {
  chk_data(data)
  bbd_chk_data_recruitment(data)
  chk_null_or(adult_female_proportion, vld = vld_range)
  chk_range(yearling_female_proportion)
  chk_whole_number(min_random_year)
  chk_gte(min_random_year)
  chk_flag(year_trend)
  chk_whole_number(year_start)
  chk_range(year_start, c(1, 12))
  chk_null_or(inits, vld = vld_vector)
  chk_null_or(inits, vld = vld_named)
  chk_flag(quiet)

  data <- model_data_recruitment(data, year_start = year_start, quiet = quiet)
  year_random <- data$datal$nAnnual >= min_random_year
  if (!year_random && year_trend) {
    if (!quiet) message_trend_fixed()
  }

  model <- model_recruitment(
    data = data$datal,
    year_random = year_random,
    year_trend = year_trend,
    adult_female_proportion = adult_female_proportion,
    yearling_female_proportion = yearling_female_proportion,
    demographic_stochasticity = FALSE,
    # not actually used for ML
    priors = priors_recruitment()
  )

  fit <- quiet_run_nimble_ml(
    model = model,
    inits = inits,
    # used to set default inits
    prior_inits = inits_recruitment(),
    quiet = quiet
  )

  convergence_fail <- ml_converge_fail(fit) || ml_se_fail(fit)
  if (convergence_fail) {
    if (!quiet) message_convergence_fail()
  }

  fit <- fit$result

  attrs <- list(
    nobs = nrow(data$data),
    converged = !convergence_fail,
    year_trend = year_trend
  )

  .attrs_bboufit_ml(fit) <- attrs

  fit$data <- data$data
  fit$model_code <- model$getCode()
  class(fit) <- c("bboufit_recruitment", "bboufit_ml")
  fit
}
