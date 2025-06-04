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
