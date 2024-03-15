#' Plot Year Recruitment
#'
#' Plot annual recruitment estimates with credible limits.
#' @inheritParams params
#' @export
bb_plot_year_recruitment <- function(x, ...) {
  UseMethod("bb_plot_year_recruitment")
}

#' @describeIn bb_plot_year_recruitment Plot annual recruitment estimate for a data frame.
#'
#' @export
bb_plot_year_recruitment.data.frame <- function(x, ...) {
  chk_unused(...)

  bb_plot_year(x) +
    scale_y_continuous("Recruitment (calves/adult female)") +
    expand_limits(y = 0)
}

#' @describeIn bb_plot_year_recruitment Plot annual recruitment estimates for a bboufit_recruitment object.
#' @inheritParams params
#' @export
bb_plot_year_recruitment.bboufit_recruitment <- function(x, conf_level = 0.95, estimate = median, ...) {
  chk_unused(...)
  x <- predict(x, conf_level = conf_level, estimate = estimate)
  bb_plot_year_recruitment(x)
}
