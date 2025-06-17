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

#' Plot Annual Recruitment Trend
#'
#' Plots annual recruitment estimates as trend line with credible limits.
#' @inheritParams params
#' @export
bb_plot_year_trend_recruitment <- function(x, ...) {
  UseMethod("bb_plot_year_trend_recruitment")
}

#' @describeIn bb_plot_year_trend_recruitment Plot annual recruitment estimate as trend line for a data frame.
#'
#' @export
bb_plot_year_trend_recruitment.data.frame <- function(x, ...) {
  chk_unused(...)
  
  plot_year_trend(x) +
    scale_y_continuous("Recruitment") +
    expand_limits(y = 0)
}

#' @describeIn bb_plot_year_trend_recruitment Plot annual estimates as trend line for a bboufit_recruitment object.
#' @inheritParams params
#' @export
bb_plot_year_trend_recruitment.bboufit_recruitment <- function(x, conf_level = 0.95, estimate = median, ...) {
  chk_unused(...)
  x <- bb_predict_recruitment_trend(x, conf_level = conf_level, estimate = estimate)
  bb_plot_year_trend_recruitment(x)
}
