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
