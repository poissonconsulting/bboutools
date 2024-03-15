#' @export
stats::logLik

#' @export
logLik.bboufit_ml <- function(object, ...) {
  object$mle$value
}
