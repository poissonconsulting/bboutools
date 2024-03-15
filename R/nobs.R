#' @export
stats::nobs

#' @export
nobs.bboufit <- function(object, ...) {
  .nobs_bboufit(object)
}

#' @export
nobs.bboufit_ml <- function(object, ...) {
  .nobs_bboufit(object)
}
