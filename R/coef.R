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

#' @export
stats::coef

#' Get Tidy Tibble from bboufit Object.
#'
#' A wrapper on [`tidy.bboufit()`].
#'
#' @inheritParams params
#' @seealso [`tidy.bboufit()`]
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_recruitment(bboudata::bbourecruit_a)
#'   coef(fit)
#' }
coef.bboufit <- function(object, ...) {
  tidy(object, ...)
}

#' Get Tidy Tibble from bboufit_ml Object.
#'
#' A wrapper on [`tidy.bboufit_ml()`].
#'
#' @inheritParams params
#' @seealso [`tidy.bboufit_ml()`]
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_recruitment_ml(bboudata::bbourecruit_a)
#'   coef(fit)
#' }
coef.bboufit_ml <- function(object, ...) {
  tidy(object, ...)
}
