#' @export
generics::augment

#' Get Augmented Data from bboufit Object
#'
#' Get a tibble of the original data with augmentation.
#'
#' @inheritParams params
#' @return A tibble of the augmented data.
#' @family generics
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival(bboudata::bbousurv_a)
#'   augment(fit)
#' }
augment.bboufit <- function(x, ...) {
  chk_unused(...)
  x$data
}

#' Get Augmented Data from bboufit_ml Object
#'
#' Get a tibble of the original data with augmentation.
#'
#' @inheritParams params
#' @return A tibble of the augmented data.
#' @family generics
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival_ml(bboudata::bbousurv_a)
#'   augment(fit)
#' }
augment.bboufit_ml <- function(x, ...) {
  chk_unused(...)
  x$data
}
