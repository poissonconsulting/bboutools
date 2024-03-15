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
                                         conf_level = 0.95,
                                         estimate = median,
                                         sig_fig = 5) {
  .chk_fit(recruitment)
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
  .chk_fit(survival)
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
