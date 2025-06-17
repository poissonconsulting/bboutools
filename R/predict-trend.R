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

predict_trend <- function(fit, derived_expr) {
  samples <- samples(fit)
  data <- augment(fit)
  new <- new_data_ym(data, year = TRUE, month = FALSE)
  x <- .predict(new_data = new, samples = samples, derived_expr = derived_expr)
  x$data$Month <- NA
  x
}

#' Predict Recruitment Trend
#'
#' Predict recruitment by year as trend line.
#' Recruitment fit object provided must be created with `year_trend = TRUE`.
#'
#' @inheritParams params
#' @return A tibble of the predicted estimates.
#' @export
#' @family analysis
bb_predict_recruitment_trend <- function(recruitment,
                                         sex_ratio = 0.5,
                                         conf_level = 0.95,
                                         estimate = median,
                                         sig_fig = 5) {
  chkor_vld(.vld_fit(recruitment), .vld_fit_ml(recruitment))
  chk_s3_class(recruitment, "bboufit_recruitment")
  .chk_year_trend(recruitment)
  chk_number(sex_ratio)
  chk_range(sex_ratio)
  chk_range(conf_level)
  chk_function(estimate)
  chk_whole_number(sig_fig)

  predicted <- predict_trend(
    fit = recruitment,
    derived_expr = derived_expr_recruitment_trend()
  )

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

#' Predict Calf-Cow Ratio Trend
#'
#' Predict calves per adult female by year as trend line.
#' Recruitment fit object provided must be created with `year_trend = TRUE`.
#'
#' @inheritParams params
#' @return A tibble of the predicted estimates.
#' @export
#' @family analysis
bb_predict_calf_cow_ratio_trend <- function(recruitment,
                                         conf_level = 0.95,
                                         estimate = median,
                                         sig_fig = 5) {
  chkor_vld(.vld_fit(recruitment), .vld_fit_ml(recruitment))
  chk_s3_class(recruitment, "bboufit_recruitment")
  .chk_year_trend(recruitment)
  chk_range(conf_level)
  chk_function(estimate)
  chk_whole_number(sig_fig)
  
  predicted <- predict_trend(
    fit = recruitment,
    derived_expr = derived_expr_recruitment_trend()
  )

  coef <- predict_coef(
    samples = predicted$samples,
    new_data = predicted$data,
    conf_level = conf_level,
    estimate = estimate,
    sig_fig = sig_fig
  )
  coef
}

#' Predict Survival Trend
#'
#' Predict survival by year as trend line.
#' Survival fit object provided must be created with `year_trend = TRUE`.
#'
#' @inheritParams params
#' @return A tibble of the predicted estimates.
#' @export
#' @family analysis
bb_predict_survival_trend <- function(survival,
                                      conf_level = 0.95,
                                      estimate = median,
                                      sig_fig = 5) {
  chkor_vld(.vld_fit(survival), .vld_fit_ml(survival))
  chk_s3_class(survival, "bboufit_survival")
  .chk_year_trend(survival)
  chk_range(conf_level)
  chk_function(estimate)
  chk_whole_number(sig_fig)

  predicted <- predict_trend(
    fit = survival,
    derived_expr = derived_expr_survival_trend()
  )
  coef <- predict_coef(
    samples = predicted$samples,
    new_data = predicted$data,
    conf_level = conf_level,
    estimate = estimate,
    sig_fig = sig_fig
  )
  coef
}
