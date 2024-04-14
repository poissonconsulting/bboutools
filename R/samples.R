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
