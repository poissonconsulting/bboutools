
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
.predict <- function(new_data, samples, derived_expr) {
  derived <- mcmcderive::mcmc_derive(samples,
    expr = derived_expr,
    monitor = "prediction",
    values = new_data,
    silent = TRUE
  )

  mcmc <- derived[["prediction"]]
  list(samples = mcmc, data = new_data)
}

predict_survival <- function(fit, year, month) {
  samples <- samples(fit)
  data <- augment(fit)
  new <- new_data_ym(data, year = year, month = month)
  derived <- derived_expr_survival(fit, year, month)
  x <- .predict(new_data = new, samples = samples, derived_expr = derived)
  if (!month) x$data$Month <- NA
  if (!year) x$data$Annual <- NA
  x
}

predict_calf_cow <- function(fit, year) {
  samples <- samples(fit)
  data <- augment(fit)
  new <- new_data_ym(data, year = year, month = FALSE)
  derived <- derived_expr_recruitment(fit, year)
  x <- .predict(new_data = new, samples = samples, derived_expr = derived)
  x$data$Month <- NA
  if (!year) x$data$Annual <- NA
  x
}

new_data_ym <- function(x, year, month) {
  seq <- c("Annual", "Month")[c(year, month)]
  df <- newdata::new_data(
    data = x,
    seq = seq
  )
  df$Year <- factor_to_integer(df$Annual)
  df <- rescale(df, data2 = x, scale = "Year")
  df
}

predict_coef <- function(samples, new_data, conf_level = 0.95,
                         estimate = median, include_pop = TRUE,
                         sig_fig = 3) {
  cols <- c("PopulationName", "CaribouYear", "Month", "estimate", "lower", "upper")
  if (!include_pop) {
    cols <- setdiff(cols, "PopulationName")
  }
  coef <- mcmcr::coef(samples, estimate = estimate, conf_level = conf_level)
  new_data$CaribouYear <- factor_to_integer(new_data$Annual)
  new_data$Annual <- NULL
  new_data$Month <- factor_to_integer(new_data$Month)
  coef <- cbind(new_data, coef)[cols]
  coef <- signif_cols(coef, sig_fig = sig_fig)
  coef <- arrange(coef, .data$CaribouYear)

  tibble::as_tibble(coef)
}

#' @export
stats::predict

#' Predict Recruitment
#'
#' A wrapper on [`bb_predict_recruitment()`].
#'
#' @inheritParams params
#' @export
#' @seealso [`bb_predict_recruitment()`]
predict.bboufit_recruitment <- function(object,
                                        year = TRUE,
                                        sex_ratio = 0.5,
                                        conf_level = 0.95,
                                        estimate = median,
                                        sig_fig = 3, ...) {
  chk_unused(...)
  bb_predict_recruitment(object,
    year = year,
    sex_ratio = sex_ratio,
    conf_level = conf_level,
    estimate = estimate,
    sig_fig = sig_fig
  )
}

#' Predict Survival
#'
#' A wrapper on [`bb_predict_survival()`].
#'
#' @inheritParams params
#' @export
#' @seealso [`bb_predict_survival()`]
predict.bboufit_survival <- function(object,
                                     year = TRUE,
                                     month = FALSE,
                                     conf_level = 0.95,
                                     estimate = median,
                                     sig_fig = 3, ...) {
  chk_unused(...)
  bb_predict_survival(object, year, month, conf_level, estimate, sig_fig)
}

#' Predict Calf-Cow Ratio
#'
#' Predict calves per adult female by year.
#' If year is FALSE, predictions are made for a 'typical' year.
#'
#' @inheritParams params
#' @return A tibble of the predicted estimates.
#' @export
#' @family analysis
bb_predict_calf_cow_ratio <- function(recruitment,
                                      year = TRUE,
                                      conf_level = 0.95,
                                      estimate = median,
                                      sig_fig = 3) {
  chkor_vld(.vld_fit(recruitment), .vld_fit_ml(recruitment))
  chk_s3_class(recruitment, "bboufit_recruitment")
  chk_flag(year)
  chk_range(conf_level)
  chk_function(estimate)
  chk_whole_number(sig_fig)

  predicted <- predict_calf_cow(fit = recruitment, year = year)
  coef <- predict_coef(
    samples = predicted$samples,
    new_data = predicted$data,
    conf_level = conf_level,
    estimate = estimate,
    sig_fig = sig_fig
  )
  coef
}

#' Predict Recruitment
#'
#' Predict adjusted recruitment by year using DeCesare et al. (2012) methods.
#' If year is FALSE, predictions are made for a 'typical' year.
#' See [bb_predict_calf_cow_ratio()] for unadjusted recruitment.
#'
#' @inheritParams params
#' @return A tibble of the predicted estimates.
#' @export
#' @references
#'   DeCesare, Nicholas J., Mark Hebblewhite, Mark Bradley, Kirby G. Smith,
#'   David Hervieux, and Lalenia Neufeld. 2012 “Estimating Ungulate Recruitment
#'   and Growth Rates Using Age Ratios.” The Journal of Wildlife Management
#'   76 (1): 144–53 https://doi.org/10.1002/jwmg.244.
#' @family analysis
bb_predict_recruitment <- function(recruitment,
                                   year = TRUE,
                                   sex_ratio = 0.5,
                                   conf_level = 0.95,
                                   estimate = median,
                                   sig_fig = 3) {
  chkor_vld(.vld_fit(recruitment), .vld_fit_ml(recruitment))
  chk_s3_class(recruitment, "bboufit_recruitment")
  chk_flag(year)
  chk_number(sex_ratio)
  chk_range(sex_ratio)
  chk_range(conf_level)
  chk_function(estimate)
  chk_whole_number(sig_fig)

  predicted <- predict_calf_cow(fit = recruitment, year = year)
  rec <- predicted$samples
  class(rec) <- "mcmcarray"
  rec <- rec * sex_ratio
  rec <- rec / (1 + rec)

  coef <- predict_coef(
    samples = rec,
    new_data = predicted$data,
    conf_level = conf_level,
    estimate = estimate,
    sig_fig = sig_fig
  )
  coef
}

#' Predict Survival
#'
#' Predict survival by year and/or month.
#' If year and month are FALSE, predictions are made for a 'typical' year and month.
#'
#' @inheritParams params
#' @return A tibble of the predicted estimates.
#' @export
#' @family analysis
bb_predict_survival <- function(survival,
                                year = TRUE,
                                month = FALSE,
                                conf_level = 0.95,
                                estimate = median,
                                sig_fig = 3) {
  chkor_vld(.vld_fit(survival), .vld_fit_ml(survival))
  chk_s3_class(survival, "bboufit_survival")
  chk_flag(year)
  chk_flag(month)
  chk_range(conf_level)
  chk_function(estimate)
  chk_whole_number(sig_fig)

  predicted <- predict_survival(survival, year = year, month = month)
  coef <- predict_coef(
    samples = predicted$samples,
    new_data = predicted$data,
    conf_level = conf_level,
    estimate = estimate,
    sig_fig = sig_fig
  )
  coef
}
