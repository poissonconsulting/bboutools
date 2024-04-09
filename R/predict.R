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
                                        conf_level = 0.95,
                                        estimate = median,
                                        sig_fig = 3, ...) {
  chk_unused(...)
  bb_predict_recruitment(object, year, conf_level, estimate, sig_fig)
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
#' Predict DeCesare adjusted recruitment by year, assuming a 50% sex ratio. 
#' If year is FALSE, predictions are made for a 'typical' year.
#' 
#' @inheritParams params
#' @return A tibble of the predicted estimates.
#' @export
#' @family analysis
bb_predict_recruitment <- function(recruitment,
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
  rec <- predicted$samples
  class(rec) <- "mcmcarray"
  rec <- rec / 2
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
