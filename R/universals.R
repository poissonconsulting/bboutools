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

terms_ml <- function(x) {
  term::as_term(c(
    x$summary$params$names,
    x$summary$randomEffects$names
  ))
}

pars_ml <- function(x) {
  term::pars_terms(terms_ml(x))
}

estimates_ml <- function(x) {
  c(
    x$summary$params$estimate,
    x$summary$randomEffects$estimate
  )
}

summary_ml <- function(x) {
  y <- tibble(
    term = terms_ml(x),
    parameter = pars_ml(x),
    estimate = estimates_ml(x)
  )
  if (!("bAnnual[1]" %in% y$term) && any(grepl("bAnnual", y$term))) {
    y <- bind_rows(y, tibble(
      term = term::as_term("bAnnual[1]"),
      parameter = "bAnnual",
      estimate = 0
    ))
  }
  arrange(y, .data$term)
}

.ess <- function(x) {
  mcmcr::ess(samples(x))
}

#' @export
universals::estimates

#' Estimates for bboufit Object
#'
#' Gets a named list of the estimated values by term.
#'
#' @inheritParams params
#' @return A named list of the estimates.
#' @seealso [`tidy.bboufit()`]
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival(bboudata::bbousurv_a)
#'   estimates(fit)
#' }
estimates.bboufit <- function(x, term = NULL, ...) {
  chkor_vld(vld_null(term), vld_character(term))
  if (!length(term)) {
    return(mcmcr::estimates(samples(x)))
  }
  mcmcr::estimates(samples(x))[[term]]
}

#' Estimates for bboufit_ml Object
#'
#' Gets a named list of the estimated values by term.
#'
#' @inheritParams params
#' @return A named list of the estimates.
#' @seealso [`tidy.bboufit()`]
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival_ml(bboudata::bbousurv_a)
#'   estimates(fit)
#' }
estimates.bboufit_ml <- function(x, term = NULL, original_scale = FALSE, ...) {
  chkor_vld(vld_null(term), vld_character(term))
  chk_flag(original_scale)
  y <- summary_ml(x)
  if (!original_scale) {
    terms_exp <- y$term[y$term %in% c("sAnnual", "sMonth")]
    terms_ilogit <- y$term[y$term %in% c("adult_female_proportion")]
    y <- transform_cols(y, terms_exp, transform = exp, cols = "estimate")
    y <- transform_cols(y, terms_ilogit, transform = nimble::ilogit, cols = "estimate")
  }
  y <- map(split(y, y$parameter), \(x) x$estimate)
  if (!length(term)) {
    return(y)
  }
  y[[term]]
}

#' @export
universals::nchains

#' Get Number of Chains from bboufit Object
#'
#' @inheritParams params
#' @return A number of the number of chains.
#' @export
nchains.bboufit <- function(x, ...) {
  mcmcr::nchains(samples(x))
}

#' @export
universals::npars

#' Get Number of Parameters from bboufit Object
#'
#' @inheritParams params
#' @return A number of the number of parameters.
#' @export
npars.bboufit <- function(x, ...) {
  mcmcr::npars(samples(x))
}

#' Get Number of Parameters from bboufit_ml Object
#'
#' @inheritParams params
#' @return A number of the number of parameters.
#' @export
npars.bboufit_ml <- function(x, ...) {
  mcmcr::npars(samples(x))
}

#' @export
universals::nterms

#' Get Number of Terms from bboufit Object
#'
#' @inheritParams params
#' @return A number of the number of terms.
#' @export
nterms.bboufit <- function(x, ...) {
  mcmcr::nterms(samples(x))
}

#' Get Number of Terms from bboufit_ml Object
#'
#' @inheritParams params
#' @return A number of the number of terms.
#' @export
nterms.bboufit_ml <- function(x, ...) {
  mcmcr::nterms(samples(x))
}

#' @export
universals::niters

#' Get Number of Iterations from bboufit Object
#'
#' @inheritParams params
#' @return A number of the number of iterations.
#' @export
niters.bboufit <- function(x, ...) {
  mcmcr::niters(samples(x))
}

#' @export
universals::rhat

#' Get Rhat of bboufit Object
#'
#' @inheritParams params
#' @return A number of rhat value.
#' @export
rhat.bboufit <- function(x, ...) {
  mcmcr::rhat(samples(x), ...)
}

#' @export
universals::esr

#' Get Effective Sample Rate of bboufit Object
#'
#' @inheritParams params
#' @return A number of the number of chains.
#' @export
esr.bboufit <- function(x, ...) {
  mcmcr::esr(samples(x), ...)
}

#' @export
universals::converged

#' Get Convergence of bboufit Object
#'
#' @inheritParams params
#' @return A flag indicating convergence.
#' @export
converged.bboufit <- function(x, rhat = 1.05, ...) {
  chk_range(rhat, c(1, 10))
  mcmcr::converged(samples(x), rhat = rhat, esr = 0, ...)
}

#' Get Convergence of bboufit_ml Object
#'
#' Successful convergence indicates that no convergence warnings were produced
#' by optim and all standard errors could be estimated.
#'
#' @inheritParams params
#' @return A flag indicating convergence.
#' @export
converged.bboufit_ml <- function(x, ...) {
  .converged_bboufit(x)
}

#' @export
universals::pars

#' Get Parameters from bboufit Object
#'
#' @inheritParams params
#' @return A vector of the parameter names.
#' @export
pars.bboufit <- function(x, ...) {
  mcmcr::pars(samples(x))
}

#' Get Parameters from bboufit_ml Object
#'
#' @inheritParams params
#' @return A vector of the parameter names.
#' @export
pars.bboufit_ml <- function(x, ...) {
  mcmcr::pars(samples(x))
}
