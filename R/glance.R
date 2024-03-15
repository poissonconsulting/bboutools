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
glance.bboufit <- function(x, ...) {
  .chk_fit(x)
  tibble::tibble(
    n = nobs(x),
    K = npars(x),
    nchains = nchains(x),
    niters = niters(x),
    nthin = .nthin_bboufit(x),
    ess = .ess(x),
    rhat = rhat(x),
    converged = converged(x)
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
