# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
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

utils::globalVariables(c(
  "Cows", "Month", "UnknownAdults", "Year", "Annual", "Yearlings",
  "adult_female_prop", "b0", "bMonth", "bYear", "fixed_proportion",
  "log<-", "logit<-", "nMonth", "nObs", "nAnnual", "year_random"
))

.rndm_seed <- function() as.integer(Sys.time())

glue2 <- function(x) {
  as.character(glue::glue(x,
    .open = "<<", .close = ">>",
    .envir = parent.frame()
  ))
}

factor_to_integer <- function(x) {
  as.integer(as.character(x))
}

signif_cols <- function(x, sig_fig = 3, cols = c("estimate", "lower", "upper")) {
  x[cols] <- map(x[cols], \(x) signif(x, sig_fig))
  x
}

message_trend_fixed <- function() {
  message("Year trend and year fixed effect cannot be fit simultaneously. Model will be fit with a year trend. To fit year fixed effect instead, set `year_trend = FALSE`")
}

message_convergence_fail <- function() {
  message("Warning: Model is failing to converge. This is likely caused by poor initial values or failure to estimate year effect. Try setting initial values, fit model with a year random effect or fit Bayesian model.")
}

exclude_random <- function(x, term_col = "term") {
  terms <- x[[term_col]]
  if ("sAnnual" %in% terms) {
    x[!grepl("bAnnual|bMonth", terms), ]
  } else {
    x[!grepl("bMonth", terms), ]
  }
}

caribou_year <- function(year, month, year_start) {
  start <- as.Date(paste(year, year_start, "01", sep = "-"))
  date_in_start <- as.Date(paste(year, month, "01", sep = "-")) >= start
  year[!date_in_start] <- year[!date_in_start] - 1L
  year
}

month_levels <- function(first, n) {
  levels <- 1:n
  if (first != 1) {
    levels <- c(first:n, 1:(first - 1))
  }
  levels
}

year_intercept <- function(x) {
  y <-
    x %>%
    dplyr::group_by(Year) %>%
    dplyr::summarize(
      mean_start = mean(.data$StartTotal),
      any_morts = sum(.data$Mortalities) >= 1
    ) %>%
    dplyr::ungroup() %>%
    dplyr::filter(.data$any_morts)

  if (nrow(y) == 0) {
    message("Warning: All years have 0 mortalities. Estimation of Confidence Intervals may not be reliable.")
    return(min(x$Year))
  }

  y <-
    y %>%
    arrange(.data$mean_start) %>%
    dplyr::slice(dplyr::n())

  y$Year
}
