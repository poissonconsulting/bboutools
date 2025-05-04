# Copyright 2022-2023 Environment and Climate Change Canada
# Copyright 2024 Province of Alberta
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

xname <- function(x, col) {
  glue::glue("Column `{col}` of `{x}`")
}

.chk_sum_less <- function(x, colsum, coltot) {
  if (.vld_sum_less(x, colsum, coltot)) {
    return(invisible())
  }
  abort_chk(glue("Sum of {chk::cc(colsum, ' and ')} must not be greater than '{coltot}'."))
}

.chk_date <- function(year, month, day) {
  chars <- paste(year, month, day, sep = "-")
  dates <- as.Date(chars)
  na_dates <- chars[is.na(dates)]
  if (!length(na_dates)) {
    return(invisible())
  }
  abort_chk(glue("Dates {chk::cc(na_dates, ' and ')} are invalid."))
}

.chk_population <- function(x) {
  if (.vld_population(x)) {
    return(invisible())
  }
  abort_chk("'PopulationName' can only contain one unique value.")
}

.chk_priors <- function(priors, req_params) {
  if (is.null(priors)) {
    return(priors)
  }
  chk_vector(priors)
  chk_named(priors)
  # use unlist in case user provides named list
  chk_numeric(unlist(priors), x_name = "Values in `priors`")
  chk_subset(names(priors), req_params, x_name = "Names in `priors`")
  invisible(priors)
}

.chk_fit <- function(x) {
  if (.vld_fit(x)) {
    return(invisible(x))
  }
  x_name <- deparse_backtick_chk(substitute(x))
  abort_chk(x_name, "must be a valid Bayesian model fit object with S3 class 'bboufit'.
            See `bb_fit_survival()` and `bb_fit_recruitment()` for details.")
}

.chk_fit_ml <- function(x) {
  if (.vld_fit_ml(x)) {
    return(invisible(x))
  }
  x_name <- deparse_backtick_chk(substitute(x))
  abort_chk(x_name, "must be a valid Maximum Likelihood model fit object with S3 class 'bboufit_ml'.
            See `bb_fit_survival_ml()` and `bb_fit_recruitment_ml()` for details.")
}

.chk_year_trend <- function(x) {
  if (.vld_year_trend(x)) {
    return(invisible(x))
  }
  abort_chk("Model fit object does not contain a year trend. See `bb_fit_survival()` and `bb_fit_recruitment()` for details.")
}

.chk_year_start_equal <- function(survival, recruitment) {
  if (.vld_year_start_equal(survival, recruitment)) {
    return(invisible(survival))
  }
  warning("Recruitment and survival models were fit with a different month of caribou year start. This can be adjusted with the `year_start` argument in model fitting functions.")
}
