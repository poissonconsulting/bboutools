#' @export
summary.bboufit <- function(object, ...) {
  summary(samples(object))
}

#' @export
summary.bboufit_ml <- function(object, ...) {
  estimates(object)
}

#' @export
print.bboufit <- function(x, ...) {
  print(summary(x))
}

#' @export
print.bboufit_ml <- function(x, ...) {
  print(summary(x))
}
