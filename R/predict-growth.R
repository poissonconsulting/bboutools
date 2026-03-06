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

predict_lambda <- function(survival, recruitment) {
  chkor_vld(.vld_fit(survival), .vld_fit_ml(survival))
  chk_s3_class(survival, "bboufit_survival")
  chkor_vld(.vld_fit(recruitment), .vld_fit_ml(recruitment))
  chk_s3_class(recruitment, "bboufit_recruitment")
  .chk_has_samples(survival)
  .chk_has_samples(recruitment)
  .chk_year_start_equal(survival, recruitment)

  sex_ratio <- .sex_ratio_bboufit(recruitment)

  pred_sur <- predict_survival(survival, year = TRUE, month = FALSE)
  pred_rec <- predict_calf_cow(recruitment, year = TRUE)

  data_sur <- pred_sur$data
  data_rec <- pred_rec$data

  sur <- pred_sur$samples
  rec <- pred_rec$samples

  .warn_filtered_multi(data_sur, data_rec)

  # match on both Annual and PopulationName
  key_sur <- interaction(data_sur$Annual, data_sur$PopulationName, drop = TRUE)
  key_rec <- interaction(data_rec$Annual, data_rec$PopulationName, drop = TRUE)

  data <- data_sur[key_sur %in% key_rec, ]

  if (!nrow(data)) {
    data <- data[c("PopulationName", "CaribouYear")]
    data$CaribouYear <- as.integer(data$CaribouYear)
    data$estimate <- numeric(0)
    data$lower <- numeric(0)
    data$upper <- numeric(0)
    return(list(lambda = list(), data = data))
  }

  sur <- sur[,, key_sur %in% key_rec, drop = FALSE]
  rec <- rec[,, key_rec %in% key_sur, drop = FALSE]
  class(sur) <- "mcmcarray"
  class(rec) <- "mcmcarray"

  rec <- rec * sex_ratio
  rec <- rec / (1 + rec)
  lambda <- sur / (1 - rec)
  list(lambda = lambda, data = data)
}

#' Predict Population Growth Lambda Samples
#'
#' Predicts population growth (lambda) from survival and recruitment fit objects using the Hatter-Bergerud equation
#' (Hatter and Bergerud, 1991).
#'
#' @inheritParams params
#' @return A 'mcmcarray' object with the modified MCMC samples.
#' @export
#' @references Hatter, Ian, and Wendy Bergerud. 1991. "Moose Recruitment, Adult
#'   Mortality and Rate of Change" 27: 65–73.
#' @family analysis
bb_predict_growth_samples <- function(survival, recruitment, sex_ratio = deprecated()) {
  if (lifecycle::is_present(sex_ratio)) {
    lifecycle::deprecate_warn(
      "1.0.0",
      "bb_predict_growth_samples(sex_ratio)",
      details = "Specify `sex_ratio` in `bb_fit_recruitment()` instead.",
      id = "sex_ratio"
    )
    chk_number(sex_ratio)
    chk_range(sex_ratio)
    .sex_ratio_bboufit(recruitment) <- sex_ratio
  }

  predict_lambda(survival, recruitment = recruitment)
}

#' Predict Population Growth Lambda
#'
#' Predicts population growth (lambda) from survival and recruitment fit objects using the Hatter-Bergerud equation
#' (Hatter and Bergerud, 1991).
#'
#' @inheritParams params
#' @return A tibble of the lambda estimates with upper and lower credible intervals.
#' @export
#' @references Hatter, Ian, and Wendy Bergerud. 1991. "Moose Recruitment, Adult
#'   Mortality and Rate of Change" 27: 65–73.
#' @family analysis
#' @examples
#' if (interactive()) {
#'   survival <- bb_fit_survival(bboudata::bbousurv_a)
#'   recruitment <- bb_fit_recruitment(bboudata::bbourecruit_a)
#'   growth <- bb_predict_growth(survival, recruitment)
#' }
bb_predict_growth <- function(
  survival,
  recruitment,
  sex_ratio = deprecated(),
  conf_level = 0.95,
  estimate = median,
  sig_fig = 3
) {
  if (lifecycle::is_present(sex_ratio)) {
    lifecycle::deprecate_warn(
      "1.0.0",
      "bb_predict_growth(sex_ratio)",
      details = "Specify `sex_ratio` in `bb_fit_recruitment()` instead.",
      id = "sex_ratio"
    )
    chk_number(sex_ratio)
    chk_range(sex_ratio)
    .sex_ratio_bboufit(recruitment) <- sex_ratio
  }
  chk_range(conf_level, c(0, 1))
  chk_is(estimate, "function")
  chk_whole_number(sig_fig)

  lambda <- bb_predict_growth_samples(
    survival,
    recruitment = recruitment
  )
  data <- lambda$data
  # no years in common
  if (!nrow(data)) {
    return(data)
  }
  lambda <- lambda$lambda
  coef <- predict_coef(
    lambda,
    new_data = data,
    include_pop = TRUE,
    conf_level = conf_level,
    estimate = estimate,
    sig_fig = sig_fig
  )
  coef$Month <- NULL
  coef
}

#' Predict Population Change Samples
#'
#' Predicts population change (%) from survival and recruitment fit objects.
#' Population change is the cumulative product of population growth rate (i.e., output of [`bb_predict_growth()`])
#'
#' @inheritParams params
#' @return A 'mcmcarray' object with the modified MCMC samples.
#' @export
#' @family analysis
bb_predict_population_change_samples <- function(
  survival,
  recruitment,
  sex_ratio = deprecated()
) {
  if (lifecycle::is_present(sex_ratio)) {
    lifecycle::deprecate_warn(
      "1.0.0",
      "bb_predict_population_change_samples(sex_ratio)",
      details = "Specify `sex_ratio` in `bb_fit_recruitment()` instead.",
      id = "sex_ratio"
    )
    chk_number(sex_ratio)
    chk_range(sex_ratio)
    .sex_ratio_bboufit(recruitment) <- sex_ratio
  }

  lambda <- predict_lambda(
    survival,
    recruitment = recruitment
  )
  data <- lambda$data
  # no years in common
  if (!nrow(data)) {
    return(lambda)
  }

  lambda_array <- lambda$lambda
  dims <- dim(lambda_array)
  pop_change <- array(dim = dims)

  populations <- unique(data$PopulationName)
  for (chain in 1:dims[1]) {
    for (iter in 1:dims[2]) {
      for (pop in populations) {
        idx <- which(data$PopulationName == pop)
        pop_change[chain, iter, idx] <- cumprod(lambda_array[chain, iter, idx])
      }
    }
  }
  class(pop_change) <- "mcmcarray"

  list(lambda = pop_change, data = data)
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
bb_predict_population_change <- function(
  survival,
  recruitment,
  sex_ratio = deprecated(),
  conf_level = 0.95,
  estimate = median,
  sig_fig = 3
) {
  if (lifecycle::is_present(sex_ratio)) {
    lifecycle::deprecate_warn(
      "1.0.0",
      "bb_predict_population_change(sex_ratio)",
      details = "Specify `sex_ratio` in `bb_fit_recruitment()` instead.",
      id = "sex_ratio"
    )
    chk_number(sex_ratio)
    chk_range(sex_ratio)
    .sex_ratio_bboufit(recruitment) <- sex_ratio
  }
  chk_range(conf_level, c(0, 1))
  chk_is(estimate, "function")
  chk_whole_number(sig_fig)

  lambda <- bb_predict_population_change_samples(
    survival,
    recruitment = recruitment
  )
  data <- lambda$data
  # no years in common
  if (!nrow(data)) {
    return(data)
  }

  pop_change <- lambda$lambda
  coef <- predict_coef(
    pop_change,
    new_data = data,
    include_pop = TRUE,
    conf_level = conf_level,
    estimate = estimate,
    sig_fig = sig_fig
  )
  coef$Month <- NULL
  start <- coef |>
    dplyr::summarise(CaribouYear = min(.data$CaribouYear) - 1L, .by = "PopulationName") |>
    dplyr::mutate(estimate = 1, lower = 1, upper = 1)
  coef <- rbind(start, coef)
  coef <- dplyr::arrange(coef, .data$PopulationName, .data$CaribouYear)
  coef
}

#' @describeIn bb_predict_growth Deprecated for `bb_predict_growth()` `r lifecycle::badge('deprecated')`
#' @export
bb_predict_lambda <- function(
  survival,
  recruitment,
  conf_level = 0.95,
  estimate = median,
  sig_fig = 3
) {
  lifecycle::deprecate_warn(
    "v0.0.1",
    "bb_predict_lambda()",
    "bb_predict_growth()"
  )
  bb_predict_growth(
    survival,
    recruitment,
    conf_level = conf_level,
    estimate = estimate,
    sig_fig = sig_fig
  )
}
