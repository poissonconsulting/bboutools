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

#' Get MCMC samples
#'
#' Get MCMC samples from Nimble model.
#' @inheritParams params
#' @export
samples <- function(x) {
  UseMethod("samples")
}

#' @describeIn samples Get MCMC samples from bboufit object.
#'
#' @export
samples.bboufit <- function(x) {
  x$samples
}

#' @describeIn samples Create MCMC samples (1 iteration, 1 chain) from bboufit_ml object.
#'
#' @export
samples.bboufit_ml <- function(x) {
  mcmcr::as.mcmcr(estimates(x))
}
