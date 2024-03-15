#' @export
stats::coef

#' Get Tidy Tibble from bboufit Object.
#'
#' A wrapper on [`tidy.bboufit()`].
#'
#' @inheritParams params
#' @seealso [`tidy.bboufit()`]
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_recruitment(bboudata::bbourecruit_a)
#'   coef(fit)
#' }
coef.bboufit <- function(object, ...) {
  tidy(object, ...)
}

#' Get Tidy Tibble from bboufit_ml Object.
#'
#' A wrapper on [`tidy.bboufit_ml()`].
#'
#' @inheritParams params
#' @seealso [`tidy.bboufit_ml()`]
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_recruitment_ml(bboudata::bbourecruit_a)
#'   coef(fit)
#' }
coef.bboufit_ml <- function(object, ...) {
  tidy(object, ...)
}
