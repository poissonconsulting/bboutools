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

plot_year_trend <- function(x, ...) {
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
      y = .data$estimate
    ) +
    geom_line() +
    xlab(" Caribou Year")

  if (any(is.na(x$lower))) {
    return(gp)
  }

  gp +
    geom_ribbon(aes(
      ymin = .data$lower,
      ymax = .data$upper
    ), alpha = 0.2)
}
