# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
# Copyright 2024 Province of Alberta
# Copyright 2025 Environment and Climate Change Canada
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

substitute_prior_values <- function(code, constants) {
  do.call(substitute, list(code, as.list(constants)))
}

# Recursively unwrap redundant { } blocks left by NIMBLE's if/else resolution.
# When NIMBLE evaluates an if branch, it wraps the result in { }, producing
# nested braces like { { for (...) { } } }. This splices each nested { }
# block's contents into its parent { } block.
clean_model_code <- function(code) {
  if (!is.call(code) || !identical(code[[1]], as.symbol("{"))) {
    return(code)
  }

  children <- list()
  for (i in seq_along(code)[-1]) {
    child <- clean_model_code(code[[i]])
    if (is.call(child) && identical(child[[1]], as.symbol("{"))) {
      for (j in seq_along(child)[-1]) {
        children <- c(children, list(child[[j]]))
      }
    } else {
      children <- c(children, list(child))
    }
  }
  as.call(c(list(as.symbol("{")), children))
}

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
