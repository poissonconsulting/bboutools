#' Plot Month
#'
#' Plots month estimates with credible limits.
#'
#' @export
bb_plot_month <- function(x, ...) {
  UseMethod("bb_plot_month")
}

#' @describeIn bb_plot_month Plot monthly estimate for a data frame.
#'
#' @export
bb_plot_month.data.frame <- function(x, ...) {
  chk_unused(...)
  check_data(x, values = list(
    Month = c(1L, 12L),
    estimate = c(0, Inf),
    lower = c(0, Inf),
    upper = c(0, Inf)
  ))

  breaks2 <- seq(2, 12, by = 2)
  if (length(x$Month)) {
    x$Month <- factor(x$Month, levels = month_levels(x$Month[1], n = 12))
  }

  # this deals with empty data.frame since scale_x_discrete doesn't like it
  gp <- ggplot(data = x) +
    aes(x = .data$Month, y = .data$estimate, ymin = .data$lower, ymax = .data$upper) +
    geom_pointrange() +
    xlab("Month")

  if (length(x$Month)) {
    return(gp + scale_x_discrete(breaks = breaks2, labels = month.abb[breaks2], drop = FALSE))
  }

  gp
}

#' @describeIn bb_plot_month Plot monthly estimates for a bboufit_survival object.
#' @inheritParams params
#' @export
bb_plot_month.bboufit_survival <- function(x, conf_level = 0.95, estimate = median, ...) {
  chk_unused(...)
  x <- predict(x, year = FALSE, month = TRUE, conf_level = conf_level, estimate = estimate)
  bb_plot_month(x)
}
