`.nthin_bboufit<-` <- function(fit, value) {
  attr(fit, "nthin") <- value
  fit
}

.nthin_bboufit <- function(fit) {
  attr(fit, "nthin", exact = TRUE)
}

`.niters_bboufit<-` <- function(fit, value) {
  attr(fit, "niters") <- value
  fit
}

.niters_bboufit <- function(fit) {
  attr(fit, "niters", exact = TRUE)
}

`.nobs_bboufit<-` <- function(fit, value) {
  attr(fit, "nobs") <- value
  fit
}

.nobs_bboufit <- function(fit) {
  attr(fit, "nobs", exact = TRUE)
}

`.converged_bboufit<-` <- function(fit, value) {
  attr(fit, "converged") <- value
  fit
}

.converged_bboufit <- function(fit) {
  attr(fit, "converged", exact = TRUE)
}

`.year_trend_bboufit<-` <- function(fit, value) {
  attr(fit, "year_trend") <- value
  fit
}

.year_trend_bboufit <- function(fit) {
  attr(fit, "year_trend", exact = TRUE)
}

.attrs_bboufit <- function(fit) {
  attrs <- attributes(fit)
  attrs[c("nthin", "nobs", "niters", "year_trend")]
}

.attrs_bboufit_ml <- function(fit) {
  attrs <- attributes(fit)
  attrs[c("nobs", "converged")]
}

`.attrs_bboufit<-` <- function(fit, value) {
  .nthin_bboufit(fit) <- value$nthin
  .niters_bboufit(fit) <- value$niters
  .nobs_bboufit(fit) <- value$nobs
  .year_trend_bboufit(fit) <- value$year_trend
  fit
}

`.attrs_bboufit_ml<-` <- function(fit, value) {
  .converged_bboufit(fit) <- value$converged
  .nobs_bboufit(fit) <- value$nobs
  fit
}
