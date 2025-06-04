
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
predict_lambda <- function(survival, recruitment, sex_ratio) {
  chkor_vld(.vld_fit(survival), .vld_fit_ml(survival))
  chk_s3_class(survival, "bboufit_survival")
  chkor_vld(.vld_fit(recruitment), .vld_fit_ml(recruitment))
  chk_s3_class(recruitment, "bboufit_recruitment")
  .chk_year_start_equal(survival, recruitment)

  pred_sur <- predict_survival(survival, year = TRUE, month = FALSE)
  pred_rec <- predict_calf_cow(recruitment, year = TRUE)

  data_sur <- pred_sur$data
  data_rec <- pred_rec$data

  sur <- pred_sur$samples
  rec <- pred_rec$samples

  data <- data_sur[data_sur$Annual %in% data_rec$Annual, ]

  if (!nrow(data)) {
    data <- data["Year"]
    data$Year <- as.integer(data$Year)
    data$estimate <- numeric(0)
    data$lower <- numeric(0)
    data$upper <- numeric(0)
    return(list(lambda = list(), data = data))
  }

  sur <- sur[, , data_sur$Annual %in% data_rec$Annual, drop = FALSE]
  rec <- rec[, , data_rec$Annual %in% data_sur$Annual, drop = FALSE]
  class(sur) <- "mcmcarray"
  class(rec) <- "mcmcarray"

  rec <- rec * sex_ratio
  rec <- rec / (1 + rec)
  lambda <- sur / (1 - rec)
  list(lambda = lambda, data = data)
}

#' Predict Population Growth Lambda
#'
#' Predicts population growth (lambda) from survival and recruitment fit objects using the Hatter-Bergerud equation
#' (Hatter and Bergerud, 1991).
#'
#' @inheritParams params
#' @return A tibble of the lambda estimates with upper and lower credible intervals.
#' @export
#' @references Hatter, Ian, and Wendy Bergerud. 1991. “Moose Recruitment, Adult
#'   Mortality and Rate of Change” 27: 65–73.
#' @family analysis
#' @examples
#' if (interactive()) {
#'   survival <- bb_fit_survival(bboudata::bbousurv_a)
#'   recruitment <- bb_fit_recruitment(bboudata::bbourecruit_a)
#'   growth <- bb_predict_growth(survival, recruitment)
#' }
bb_predict_growth <- function(survival,
                              recruitment,
                              sex_ratio = 0.5,
                              conf_level = 0.95,
                              estimate = median,
                              sig_fig = 3) {
  chk_number(sex_ratio)
  chk_range(sex_ratio)
  chk_range(conf_level, c(0, 1))
  chk_is(estimate, "function")
  chk_whole_number(sig_fig)

  lambda <- predict_lambda(survival,
    recruitment = recruitment,
    sex_ratio = sex_ratio
  )
  data <- lambda$data
  # no years in common
  if (!nrow(data)) {
    return(data)
  }
  lambda <- lambda$lambda
  coef <- predict_coef(lambda,
    new_data = data, include_pop = FALSE,
    conf_level = conf_level, estimate = estimate,
    sig_fig = sig_fig
  )
  coef$Month <- NULL
  coef
}

#' Predict Population Change
#'
#' Predicts population change (%) from survival and recruitment fit objects.
#' Population change is the cumulative product of population growth rate (i.e., output of [`bb_predict_growth()`])
#'
#' @inheritParams params
#' @return A tibble of the population change estimates with upper and lower credible intervals.
#' @export
#' @family analysis
#' @examples
#' if (interactive()) {
#'   survival <- bb_fit_survival(bboudata::bbousurv_a)
#'   recruitment <- bb_fit_recruitment(bboudata::bbourecruit_a)
#'   change <- bb_predict_population_change(survival, recruitment)
#' }
bb_predict_population_change <- function(survival,
                                         recruitment,
                                         sex_ratio = 0.5,
                                         conf_level = 0.95,
                                         estimate = median,
                                         sig_fig = 3) {
  chk_number(sex_ratio)
  chk_range(sex_ratio)
  chk_range(conf_level, c(0, 1))
  chk_is(estimate, "function")
  chk_whole_number(sig_fig)

  lambda <- predict_lambda(survival,
    recruitment = recruitment,
    sex_ratio = sex_ratio
  )
  data <- lambda$data
  # no years in common
  if (!nrow(data)) {
    return(data)
  }

  lambda <- lambda$lambda
  dims <- dim(lambda)
  pop_change <- array(dim = dims)
  for (chain in 1:dims[1]) {
    for (iter in 1:dims[2]) {
      pop_change[chain, iter, ] <- cumprod(lambda[chain, iter, ])
    }
  }
  class(pop_change) <- "mcmcarray"
  coef <- predict_coef(pop_change,
    new_data = data, include_pop = FALSE,
    conf_level = conf_level, estimate = estimate,
    sig_fig = sig_fig
  )
  coef$Month <- NULL
  start <- tibble::tibble(CaribouYear = min(coef$CaribouYear) - 1L, estimate = 1, lower = 1, upper = 1)
  coef <- rbind(start, coef)
  coef
}

#' @describeIn bb_predict_growth Deprecated for `bb_predict_growth()` `r lifecycle::badge('deprecated')`
#' @export
bb_predict_lambda <- function(survival,
                              recruitment,
                              conf_level = 0.95,
                              estimate = median,
                              sig_fig = 3) {
  lifecycle::deprecate_soft("v0.0.1", "bb_predict_lambda()", "bb_predict_growth()")
  bb_predict_growth(survival, recruitment,
    conf_level = conf_level,
    estimate = estimate,
    sig_fig = sig_fig
  )
}
