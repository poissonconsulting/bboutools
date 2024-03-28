#' @export
samples <- function(x) {
  UseMethod("samples")
}

#' @export
samples.bboufit <- function(x) {
  x$samples
}

#' @export
samples.bboufit_ml <- function(x) {
  mcmcr::as.mcmcr(estimates(x))
}
