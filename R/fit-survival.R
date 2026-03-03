# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
# Copyright 2024 Province of Alberta
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
ml_converge_fail <- function(x) {
  grepl(
    "Warning: optim does not converge for the inner optimization of AGHQuad or Laplace approximation",
    x$output
  )
}
ml_se_fail <- function(x) {
  any(is.nan(x$result$summary$params$stdError))
}

stochastic_var_names <- function(model) {
  nodes <- model$getNodeNames(stochOnly = TRUE, includeData = FALSE)
  unique(sub("\\[.*\\]", "", nodes))
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
bb_fit_survival <- function(
  data,
  min_random_year = 5,
  year_trend = FALSE,
  include_uncertain_morts = TRUE,
  year_start = 4L,
  nthin = 10,
  niters = 1000,
  priors = NULL,
  allow_missing = FALSE,
  quiet = FALSE
) {
  chk_data(data)
  chk_flag(allow_missing)
  bbd_chk_data_survival(data, multi_population = TRUE, allow_missing = allow_missing)
  chk_whole_number(min_random_year)
  chk_gte(min_random_year)
  chk_flag(year_trend)
  chk_flag(include_uncertain_morts)
  chk_whole_number(year_start)
  chk_range(year_start, c(1, 12))
  chk_whole_number(nthin)
  chk_gt(nthin)
  chk_whole_number(niters)
  chk_gte(niters)
  default_priors <- priors_survival()
  .chk_priors(priors, names(default_priors))
  chk_flag(quiet)

  priors <- replace_priors(default_priors, priors)
  data <-
    model_data_survival(
      data,
      include_uncertain_morts = include_uncertain_morts,
      year_start = year_start,
      allow_missing = allow_missing,
      quiet = quiet
    )
  nAnnual <- if (allow_missing) data$nAnnualObserved else data$datal$nAnnual
  year_random <- nAnnual >= min_random_year
  if (allow_missing && !year_random) {
    abort_chk("`allow_missing` requires year to be fit as a random effect. Increase the number of observed years or decrease `min_random_year`.")
  }
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
    year_trend = year_trend,
    year_start = year_start
  )

  .attrs_bboufit(fit) <- attrs
  fit$data <- data$data
  fit$model_code <- model$getCode()
  class(fit) <- c("bboufit_survival", "bboufit")
  fit
}
