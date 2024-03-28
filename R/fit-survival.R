ml_converge_fail <- function(x) {
  grepl(
    "Warning: optim does not converge for the inner optimization of AGHQuad or Laplace approximation",
    x$output
  )
}
ml_se_fail <- function(x) {
  any(is.nan(x$result$summary$params$stdErrors))
}

#' Fit Survival Model
#'
#' Fits hierarchical Bayesian survival model using Nimble.
#' 
#' If the number of years is > `min_random_year`, a fixed-effects model is fit.
#' Otherwise, a mixed-effects model is fit with random intercept for each year.
#' If `year_trend` is TRUE and the number of years is > `min_random_year`, the model 
#' will be fit with year as a continuous effect (i.e. trend) and no fixed effect of year. 
#' If `year_trend` is TRUE and the number of years is <= `min_random_year`, the model 
#' will be fit with year as a continuous effect and a random intercept for each year.
#'
#' The model is always fit with random intercept for each month.
#' 
#' The start month of the Caribou year can be adjusted with `year_start`.
#'
#' @inheritParams params
#' @return A list of the Nimble model object, data and mcmcr samples.
#' @export
#' @family model
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival(bboudata::bbousurv_a)
#' }
bb_fit_survival <- function(data,
                            min_random_year = 5,
                            year_trend = FALSE,
                            include_uncertain_morts = FALSE,
                            year_start = 4L,
                            nthin = 10,
                            niters = 1000,
                            priors = NULL,
                            quiet = FALSE) {
  chk_data(data)
  bbd_chk_data_survival(data)
  chk_whole_number(min_random_year)
  chk_gte(min_random_year)
  chk_flag(year_trend)
  chk_flag(include_uncertain_morts)
  chk_whole_number(year_start)
  chk_range(year_start, c(1, 12))
  chk_whole_number(nthin)
  chk_gt(nthin)
  chk_whole_number(niters)
  chk_gt(niters)
  default_priors <- priors_survival()
  .chk_priors(priors, names(default_priors))
  chk_flag(quiet)

  priors <- replace_priors(default_priors, priors)
  data <-
    model_data_survival(data,
      include_uncertain_morts = include_uncertain_morts,
      year_start = year_start, quiet = quiet
    )
  year_random <- data$datal$nAnnual >= min_random_year
  if (!year_random && year_trend) {
    message_trend_fixed()
  }

  model <-
    model_survival(
      data = data$datal,
      year_random = year_random,
      year_trend = year_trend,
      priors = priors
    )

  params <- params_survival()
  vars <- model$getVarNames()
  monitor <- params[params %in% vars]

  fit <- run_nimble(
    model = model,
    monitor = monitor,
    inits = NULL,
    niters = niters,
    nchains = 3L,
    nthin = nthin,
    quiet = quiet
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
  class(fit) <- c("bboufit_survival", "bboufit")
  fit
}


#' Fit Survival Model with Maximum Likelihood
#'
#' Fits hierarchical survival model with Maximum Likelihood using Nimble Laplace approximation.
#' 
#' If the number of years is > `min_random_year`, a fixed-effects model is fit.
#' Otherwise, a mixed-effects model is fit with random intercept for each year.
#' If `year_trend` is TRUE and the number of years is > `min_random_year`, the model 
#' will be fit with year as a continuous effect (i.e. trend) and no fixed effect of year. 
#' If `year_trend` is TRUE and the number of years is <= `min_random_year`, the model 
#' will be fit with year as a continuous effect and a random intercept for each year.
#'
#' The model is always fit with random intercept for each month.
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
#'   fit <- bb_fit_survival_ml(bboudata::bbousurv_a)
#' }
bb_fit_survival_ml <- function(data,
                               min_random_year = 5,
                               year_trend = FALSE,
                               include_uncertain_morts = FALSE,
                               year_start = 4L,
                               exclude_year = FALSE,
                               inits = NULL,
                               quiet = FALSE) {
  chk_data(data)
  bbd_chk_data_survival(data)
  chk_whole_number(min_random_year)
  chk_gte(min_random_year)
  chk_flag(year_trend)
  chk_flag(include_uncertain_morts)
  chk_whole_number(year_start)
  chk_range(year_start, c(1, 12))
  chk_flag(exclude_year)
  chk_null_or(inits, vld = vld_vector)
  chk_null_or(inits, vld = vld_named)
  chk_flag(quiet)

  data <-
    model_data_survival(data,
      include_uncertain_morts = include_uncertain_morts,
      year_start = year_start, quiet = quiet
    )
  year_random <- data$datal$nAnnual >= min_random_year
  if (!year_random && year_trend && !exclude_year) {
    if(!quiet) message_trend_fixed()
  }

  model <-
    model_survival(
      data = data$datal,
      year_random = year_random,
      year_trend = year_trend,
      priors = priors_survival(),
      exclude_year = exclude_year
    )

  fit <- quiet_run_nimble_ml(
    model = model,
    inits = inits,
    prior_inits = inits_survival(),
    quiet = quiet
  )

  convergence_fail <- ml_converge_fail(fit) || ml_se_fail(fit)
  if (convergence_fail) {
    if(!quiet) message_convergence_fail()
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
  class(fit) <- c("bboufit_survival", "bboufit_ml")
  fit
}
