.vld_sum_less <- function(x, colsum, coltot) {
  all(rowSums(x[colsum]) <= x[[coltot]])
}

.vld_fit <- function(x) {
  all(
    vld_s3_class(x, "bboufit"),
    vld_subset(names(x), c("model", "samples", "data", "model_code")),
    vld_true(all(names(attributes(x)) %in% c("names", "nthin", "model", "nobs", "niters", "year_trend", "class"))),
    vld_s3_class(x$samples, "mcmcr")
  )
}

.vld_fit_ml <- function(x) {
  all(
    vld_s3_class(x, "bboufit_ml"),
    vld_subset(names(x), c("summary", "mle", "model", "data", "model_code")),
    vld_s4_class(x$summary, "AGHQuad_summary"),
    vld_s4_class(x$mle, "OptimResultNimbleList")
  )
}

.vld_population <- function(x) {
  length(unique(x$PopulationName)) == 1L
}

.vld_year_trend <- function(x) {
  attr(x, "year_trend")
}
