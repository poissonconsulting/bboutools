#' Plot Monthly Survival
#'
#' Plots monthly survival estimates with credible limits.
#' Estimates represent annual survival if a given month lasted the entire year.
#'
#' @inheritParams params
#' @export
bb_plot_month_survival <- function(x, ...) {
  UseMethod("bb_plot_month_survival")
}

#' @describeIn bb_plot_month_survival Plot monthly survival estimate for a data frame.
#'
#' @export
bb_plot_month_survival.data.frame <- function(x, ...) {
  chk_unused(...)

  bb_plot_month(x) +
    scale_y_continuous("Annual Survival (%)", labels = percent)
}

#' @describeIn bb_plot_month_survival Plot monthly survival estimates for a bboufit_survival object.
#' @inheritParams params
#' @export
bb_plot_month_survival.bboufit_survival <- function(x, conf_level = 0.95, estimate = median, ...) {
  chk_unused(...)
  x <- predict(x, year = FALSE, month = TRUE, conf_level = conf_level, estimate = estimate)
  bb_plot_month_survival(x)
}
