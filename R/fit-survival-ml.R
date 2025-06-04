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
  chk_null_or(inits, vld = vld_vector)
  chk_null_or(inits, vld = vld_named)
  chk_flag(quiet)

  # special treatment of intercept for ML fixed
  data <- data_clean_survival(data, quiet = quiet)
  data <- data_prep_survival(data,
    include_uncertain_morts = include_uncertain_morts,
    year_start = year_start
  )
  year_random <- length(unique(data$Year)) >= min_random_year
  if (!year_random) {
    data <- data_adjust_intercept(data)
  }

  datal <- data_list_survival(data)
  data <- list(datal = datal, data = data)

  if (!year_random && year_trend) {
    if (!quiet) message_trend_fixed()
  }

  model <-
    model_survival(
      data = data$datal,
      year_random = year_random,
      year_trend = year_trend,
      priors = priors_survival()
    )

  fit <- quiet_run_nimble_ml(
    model = model,
    inits = inits,
    prior_inits = inits_survival(),
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
    year_trend = year_trend,
    year_start = year_start
  )

  .attrs_bboufit_ml(fit) <- attrs

  fit$data <- data$data
  fit$model_code <- model$getCode()
  class(fit) <- c("bboufit_survival", "bboufit_ml")
  fit
}
