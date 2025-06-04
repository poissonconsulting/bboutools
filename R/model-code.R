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

#' Get Model Code
#'
#' Get code from Nimble model.
#' @inheritParams params
#' @export
model_code <- function(x, ...) {
  UseMethod("model_code")
}

#' @describeIn model_code Get model code from bboufit object.
#'
#' @export
model_code.bboufit <- function(x, ...) {
  chk_unused(...)
  .chk_fit(x)
  x$model_code
}

#' @describeIn model_code Get model code from bboufit_ml object.
#'
#' @export
model_code.bboufit_ml <- function(x, ...) {
  chk_unused(...)
  .chk_fit_ml(x)
  x$model_code
}
