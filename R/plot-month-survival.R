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
