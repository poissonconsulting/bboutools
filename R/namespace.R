# Copyright 2022 Environment and Climate Change Canada
# Copyright 2023 Province of Alberta
# Copyright 2024 Province of Alberta
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' @import chk glue nimble magrittr
#' @importFrom stats rnorm
#' @importFrom scales percent
#' @importFrom rescale rescale
#' @importFrom dplyr arrange tibble bind_rows left_join
#' @importFrom purrr quietly map map_dbl map_lgl
#' @importFrom stats setNames update median coef predict nobs plogis runif qnorm logLik
#' @importFrom ggplot2 autoplot .data ggplot aes geom_pointrange geom_hline scale_x_continuous scale_x_discrete scale_y_continuous expand_limits xlab geom_line geom_ribbon
#' @importFrom utils modifyList
#' @importFrom generics augment glance tidy
#' @importFrom universals estimates nchains npars nterms niters rhat esr converged pars
#' @importFrom bboudata bbd_chk_data_recruitment bbd_chk_data_survival
NULL
