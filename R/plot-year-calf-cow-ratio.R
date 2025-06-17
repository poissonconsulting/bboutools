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

#' Plot Year Calf-Cow Ratio
#'
#' Plot annual calf-cow ratio estimates with credible limits.
#'
#' @inheritParams params
#' @export
bb_plot_year_calf_cow_ratio <- function(x, ...) {
  UseMethod("bb_plot_year_calf_cow_ratio")
}

#' @describeIn bb_plot_year_calf_cow_ratio Plot annual recruitment estimate for a data frame.
#'
#' @export
bb_plot_year_calf_cow_ratio.data.frame <- function(x, ...) {
  chk_unused(...)
  
  bb_plot_year(x) +
    scale_y_continuous('Calves per Adult Female') +
    expand_limits(y = 0)
}

#' @describeIn bb_plot_year_calf_cow_ratio Plot annual calf-cow ratio estimates for a bboufit_recruitment object.
#' @inheritParams params
#' @export
bb_plot_year_calf_cow_ratio.bboufit_recruitment <- function(x, conf_level = 0.95, estimate = median, ...) {
  chk_unused(...)
  x <- bb_predict_calf_cow_ratio(x, conf_level = conf_level, estimate = estimate)
  bb_plot_year_calf_cow_ratio(x)
}
