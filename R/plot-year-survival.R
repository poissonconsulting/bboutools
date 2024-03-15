#' Plot Year Survival
#'
#' Plots annual survival estimates with credible limits.
#' @inheritParams params
#' @export
bb_plot_year_survival <- function(x, ...) {
  UseMethod("bb_plot_year_survival")
}

#' @describeIn bb_plot_year_survival Plot annual survival estimate for a data frame.
#'
#' @export
bb_plot_year_survival.data.frame <- function(x, ...) {
  chk_unused(...)

  bb_plot_year(x) +
    scale_y_continuous("Annual Survival (%)", labels = percent)
}

#' @describeIn bb_plot_year_survival Plot annual survival estimates for a bboufit_survival object.
#' @inheritParams params
#' @export
bb_plot_year_survival.bboufit_survival <- function(x, conf_level = 0.95, estimate = median, ...) {
  chk_unused(...)
  x <- predict(x, conf_level = conf_level, estimate = estimate)
  bb_plot_year_survival(x)
}
