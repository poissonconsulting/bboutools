#' @export
plot.bboufit <- function(x, term = character(0), ...) {
  mcmc <- samples(x)
  if (length(term)) {
    mcmc <- mcmc[[term]]
  }
  plot(mcmc)
}
