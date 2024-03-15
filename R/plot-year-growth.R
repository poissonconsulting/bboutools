#' Plot Year Population Growth
#'
#' Plots annual population growth with credible limits.
#' @param x A data frame of the lambda estimates (output of [`bb_predict_growth()`]).
#' @export
bb_plot_year_growth <- function(x) {
  chk_data(x)

  bb_plot_year(x) +
    scale_y_continuous("Population Growth (lambda)") +
    geom_hline(yintercept = 1, linetype = "dashed", alpha = 1 / 2) +
    expand_limits(y = c(0, 1))
}

#' Plot Year Population Change
#'
#' Plots annual population change (%) with credible limits.
#' @param x A data frame of the population change estimates (output of [`bb_predict_population_change()`]).
#' @export
bb_plot_year_population_change <- function(x) {
  chk_data(x)
  
  plot_year_trend(x) +
    scale_y_continuous("Population Change", labels = percent) +
    expand_limits(y = c(0, NA))
}
