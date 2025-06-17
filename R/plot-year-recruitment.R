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

#' Plot Year Recruitment
#'
#' Plot annual recruitment estimates with credible limits.
#' Recruitment is adjusted following DeCesare et al. (2012) methods.
#'
#' @inheritParams params
#' @references
#'   DeCesare, Nicholas J., Mark Hebblewhite, Mark Bradley, Kirby G. Smith,
#'   David Hervieux, and Lalenia Neufeld. 2012 “Estimating Ungulate Recruitment
#'   and Growth Rates Using Age Ratios.” The Journal of Wildlife Management
#'   76 (1): 144–53 https://doi.org/10.1002/jwmg.244.
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
    scale_y_continuous('Adjusted Recruitment') +
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
