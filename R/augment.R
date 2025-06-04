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
generics::augment

#' Get Augmented Data from bboufit Object
#'
#' Get a tibble of the original data with augmentation.
#'
#' @inheritParams params
#' @return A tibble of the augmented data.
#' @family generics
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival(bboudata::bbousurv_a)
#'   augment(fit)
#' }
augment.bboufit <- function(x, ...) {
  chk_unused(...)
  x$data
}

#' Get Augmented Data from bboufit_ml Object
#'
#' Get a tibble of the original data with augmentation.
#'
#' @inheritParams params
#' @return A tibble of the augmented data.
#' @family generics
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival_ml(bboudata::bbousurv_a)
#'   augment(fit)
#' }
augment.bboufit_ml <- function(x, ...) {
  chk_unused(...)
  x$data
}
