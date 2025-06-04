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
#' The start month of the Caribou year can be adjusted with `year_start`.
#'
#' @inheritParams params
#' @param sex_ratio A number between 0 and 1 of the proportion of females at birth.
#' This proportion is applied to yearlings.
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
    sex_ratio = 0.5,
    min_random_year = 5,
    year_trend = FALSE,
    year_start = 4L,
    inits = NULL,
    quiet = FALSE) {
  chk_data(data)
  bbd_chk_data_recruitment(data)
  chk_null_or(adult_female_proportion, vld = vld_range)
  chk_range(sex_ratio)
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
    sex_ratio = sex_ratio,
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
    year_trend = year_trend,
    year_start = year_start
  )

  .attrs_bboufit_ml(fit) <- attrs

  fit$data <- data$data
  fit$model_code <- model$getCode()
  class(fit) <- c("bboufit_recruitment", "bboufit_ml")
  fit
}
