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
generics::glance

#' Get a Glance Summary of bboufit Object
#'
#' Get a tibble of a one-row summary of the model fit.
#'
#' @inheritParams params
#' @return A tibble of the glance summary.
#' @family generics
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival(bboudata::bbousurv_a)
#'   glance(fit)
#' }
glance.bboufit <- function(x, rhat = 1.05, ...) {
  .chk_fit(x)
  converge <- converged(x, rhat = rhat)
  tibble::tibble(
    n = nobs(x),
    K = npars(x),
    nchains = nchains(x),
    niters = niters(x),
    nthin = .nthin_bboufit(x),
    ess = .ess(x),
    rhat = rhat(x),
    converged = converge
  )
}

#' Get a Glance Summary of bboufit_ml Object
#'
#' Get a tibble of a one-row summary of the model fit.
#'
#' @inheritParams params
#' @return A tibble of the glance summary.
#' @family generics
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival_ml(bboudata::bbousurv_a)
#'   glance(fit)
#' }
glance.bboufit_ml <- function(x, ...) {
  .chk_fit_ml(x)
  tibble::tibble(
    n = nobs(x),
    K = npars(x),
    loglik = logLik(x),
    converged = .converged_bboufit(x)
  )
}
