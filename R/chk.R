# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
# Copyright 2024 Province of Alberta
# Copyright 2025 Environment and Climate Change Canada
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
  abort_chk(glue(
    "Sum of {chk::cc(colsum, ' and ')} must not be greater than '{coltot}'."
  ))
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
  abort_chk(
    x_name,
    "must be a valid Bayesian model fit object with S3 class 'bboufit'.
            See `bb_fit_survival()` and `bb_fit_recruitment()` for details."
  )
}

.chk_fit_ml <- function(x) {
  if (.vld_fit_ml(x)) {
    return(invisible(x))
  }
  x_name <- deparse_backtick_chk(substitute(x))
  abort_chk(
    x_name,
    "must be a valid Maximum Likelihood model fit object with S3 class 'bboufit_ml'.
            See `bb_fit_survival_ml()` and `bb_fit_recruitment_ml()` for details."
  )
}

.chk_year_trend <- function(x) {
  if (.vld_year_trend(x)) {
    return(invisible(x))
  }
  abort_chk(
    "Model fit object does not contain a year trend. See `bb_fit_survival()` and `bb_fit_recruitment()` for details."
  )
}

.inform_unobserved_years <- function(placeholder_data, unobserved_years) {
  parts <- dplyr::tibble(
    PopulationName = placeholder_data$PopulationName,
    CaribouYear = as.character(unobserved_years)
  ) |>
    dplyr::distinct() |>
    dplyr::arrange(.data$PopulationName, .data$CaribouYear) |>
    dplyr::summarise(
      years = paste(.data$CaribouYear, collapse = ", "),
      .by = "PopulationName"
    ) |>
    dplyr::mutate(part = paste0(.data$PopulationName, " (", .data$years, ")")) |>
    dplyr::pull("part")

  message(
    "Detected unobserved CaribouYear(s) from placeholder rows: ",
    paste(parts, collapse = "; "),
    "."
  )
}

.warn_filtered_multi <- function(data_sur, data_rec) {
  by <- c("Annual", "PopulationName")

  sur_pops <- unique(as.character(data_sur$PopulationName))
  rec_pops <- unique(as.character(data_rec$PopulationName))
  pops_sur_only <- setdiff(sur_pops, rec_pops)
  pops_rec_only <- setdiff(rec_pops, sur_pops)

  # for shared populations, find years only in one side
  shared_sur <- dplyr::filter(data_sur, .data$PopulationName %in% rec_pops)
  shared_rec <- dplyr::filter(data_rec, .data$PopulationName %in% sur_pops)
  years_sur_only <- dplyr::anti_join(shared_sur, shared_rec, by = by)$Annual |>
    unique() |>
    sort()
  years_rec_only <- dplyr::anti_join(shared_rec, shared_sur, by = by)$Annual |>
    unique() |>
    sort()

  has_pop_diff <- length(pops_sur_only) || length(pops_rec_only)
  has_year_diff <- length(years_sur_only) || length(years_rec_only)
  if (!has_pop_diff && !has_year_diff) {
    return(invisible())
  }

  details <- character(0)
  if (length(pops_sur_only)) {
    details <- c(details, paste0(
      "Populations in survival only: ",
      paste(pops_sur_only, collapse = ", ")
    ))
  }
  if (length(pops_rec_only)) {
    details <- c(details, paste0(
      "Populations in recruitment only: ",
      paste(pops_rec_only, collapse = ", ")
    ))
  }
  if (length(years_sur_only)) {
    details <- c(details, paste0(
      "CaribouYears in survival only: ",
      paste(years_sur_only, collapse = ", ")
    ))
  }
  if (length(years_rec_only)) {
    details <- c(details, paste0(
      "CaribouYears in recruitment only: ",
      paste(years_rec_only, collapse = ", ")
    ))
  }
  message(
    "Filtering to shared population and year combinations. ",
    paste(details, collapse = ". "),
    "."
  )
}


.chk_has_samples <- function(x) {
  if (!inherits(x, "bboufit") || inherits(x, "bboufit_ml")) {
    return(invisible(x))
  }
  niters <- .niters_bboufit(x)
  if (is.null(niters) || niters > 0) {
    return(invisible(x))
  }
  abort_chk(
    "Model has 0 iterations and no MCMC samples. Refit with `niters > 0`."
  )
}

.chk_disturbance <- function(anthro, fire_excl_anthro) {
  chk_number(anthro)
  chk_number(fire_excl_anthro)
  chk_range(anthro, c(0, 100))
  chk_range(fire_excl_anthro, c(0, 100))
  if (!.vld_disturbance(anthro, fire_excl_anthro)) {
    abort_chk("`anthro + fire_excl_anthro` must not be greater than 100.")
  }
  invisible()
}

.chk_year_start_equal <- function(survival, recruitment) {
  if (.vld_year_start_equal(survival, recruitment)) {
    return(invisible(survival))
  }
  cli::cli_warn(c(
    "Recruitment and survival models were fit with a different month of caribou year start.",
    "i" = "This can be adjusted with the {.arg year_start} argument in model fitting functions."
  ))
}
