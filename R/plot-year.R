#' Plot Year
#'
#' Plots annual estimates with credible limits.
#' @inheritParams params
#' @export
bb_plot_year <- function(x, ...) {
  UseMethod("bb_plot_year")
}

#' @describeIn bb_plot_year Plot annual estimate for a data frame.
#' @inheritParams params
#' @export
bb_plot_year.data.frame <- function(x, ...) {
  chk_unused(...)
  check_data(x, values = list(
    CaribouYear = 1L,
    estimate = c(0, Inf),
    lower = c(0, Inf),
    upper = c(0, Inf)
  ))

  ggplot(data = x) +
    aes(
      x = as.integer(.data$CaribouYear),
      y = .data$estimate,
      ymin = .data$lower,
      ymax = .data$upper
    ) +
    geom_pointrange() +
    xlab("Caribou Year")
}

#' @describeIn bb_plot_year Plot annual estimates for a bboufit object.
#' @inheritParams params
#' @export
bb_plot_year.bboufit <- function(x, conf_level = 0.95, estimate = median, ...) {
  chk_unused(...)
  x <- predict(x, conf_level = conf_level, estimate = estimate)
  bb_plot_year(x)
}
