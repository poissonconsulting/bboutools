# Copyright 2022-2023 Environment and Climate Change Canada
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
    lower = c(0, Inf, NA),
    upper = c(0, Inf, NA)
  ))

  gp <- ggplot(data = x) +
    aes(
      x = as.integer(.data$CaribouYear),
      y = .data$estimate,
      ymin = .data$lower,
      ymax = .data$upper
    ) +
    xlab("Caribou Year")

  if (any(is.na(x$lower))) {
    return(gp + ggplot2::geom_point())
  }
  gp + geom_pointrange()
}

#' @describeIn bb_plot_year Plot annual estimates for a bboufit object.
#' @inheritParams params
#' @export
bb_plot_year.bboufit <- function(x, conf_level = 0.95, estimate = median, ...) {
  chk_unused(...)
  x <- predict(x, conf_level = conf_level, estimate = estimate)
  bb_plot_year(x)
}

#' @describeIn bb_plot_year Plot annual estimates for a bboufit_ml object.
#' @inheritParams params
#' @export
bb_plot_year.bboufit_ml <- function(x, conf_level = 0.95, estimate = median, ...) {
  chk_unused(...)
  x <- predict(x, conf_level = conf_level, estimate = estimate)
  bb_plot_year(x)
}
