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

# --- Placeholder data helpers ---

prior_only_surv <- function() {
  data.frame(
    PopulationName = rep("A", 3),
    Year = 2020:2022,
    Month = NA_integer_,
    StartTotal = NA_integer_,
    MortalitiesCertain = NA_integer_,
    MortalitiesUncertain = NA_integer_
  )
}

prior_only_recruit <- function() {
  data.frame(
    PopulationName = rep("A", 3),
    Year = 2020:2022,
    Month = NA_integer_,
    Day = NA_integer_,
    Cows = NA_integer_,
    Bulls = NA_integer_,
    UnknownAdults = NA_integer_,
    Yearlings = NA_integer_,
    Calves = NA_integer_
  )
}

# --- Data pipeline tests ---

test_that("model_data_survival handles prior-only data", {
  x <- prior_only_surv()
  result <- model_data_survival(
    x,
    include_uncertain_morts = TRUE,
    year_start = 4L,
    allow_missing = TRUE,
    quiet = TRUE
  )

  expect_identical(result$nAnnualObserved, 0L)
  expect_identical(result$datal$nObs, 0L)
  expect_identical(result$datal$nAnnual, 3L)
  expect_identical(result$datal$nMonth, 12L)
  expect_identical(result$datal$nPopulation, 1L)
  expect_identical(nrow(result$data), 0L)
  expect_identical(length(levels(result$data$Annual)), 3L)
  expect_identical(length(levels(result$data$Month)), 12L)
})

test_that("model_data_recruitment handles prior-only data", {
  x <- prior_only_recruit()
  result <- model_data_recruitment(
    x,
    year_start = 4L,
    allow_missing = TRUE,
    quiet = TRUE
  )

  expect_identical(result$nAnnualObserved, 0L)
  expect_identical(result$datal$nObs, 0L)
  expect_identical(result$datal$nAnnual, 3L)
  expect_identical(result$datal$nPopulation, 1L)
  expect_identical(nrow(result$data), 0L)
  expect_identical(length(levels(result$data$Annual)), 3L)
})

# --- Fit + predict tests ---

test_that("bb_fit_survival works with prior-only data", {
  skip_on_covr()

  x <- prior_only_surv()
  priors <- bb_priors_survival_national(anthro = 50, fire_excl_anthro = 50)
  priors <- c(priors, c(sAnnual_rate = 10, bYear_mu = -1, bYear_sd = 0.1))
  set.seed(101)
  fit <- bb_fit_survival(
    data = x,
    niters = 10,
    nthin = 1,
    allow_missing = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(nrow(fit$data), 0L)

  pred <- bb_predict_survival(fit)
  expect_s3_class(pred, "tbl_df")
  expect_gt(nrow(pred), 0)
  expect_true(all(pred$CaribouYear %in% 2020:2022))
  expect_snapshot_data(pred, "survival_pred_prior_only")
})

test_that("bb_fit_recruitment works with prior-only data", {
  skip_on_covr()

  x <- prior_only_recruit()
  priors <- bb_priors_recruitment_national(anthro = 50, fire_excl_anthro = 50)
  priors <- c(priors, c(sAnnual_rate = 10, bYear_mu = -1, bYear_sd = 0.1))
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x,
    niters = 100,
    nthin = 1,
    allow_missing = TRUE,
    year_trend = TRUE,
    priors = priors,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(nrow(fit$data), 0L)

  pred <- bb_predict_recruitment(fit)
  expect_s3_class(pred, "tbl_df")
  expect_gt(nrow(pred), 0)
  expect_true(all(pred$CaribouYear %in% 2020:2022))
  expect_snapshot_data(pred, "recruitment_pred_prior_only")
})

# --- niters = 0 + prior-only ---

test_that("bb_fit_survival with niters 0 and prior-only data works", {
  skip_on_covr()

  x <- prior_only_surv()
  set.seed(101)
  fit <- bb_fit_survival(
    data = x,
    niters = 0,
    allow_missing = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(nrow(fit$data), 0L)
})

test_that("bb_fit_recruitment with niters 0 and prior-only data works", {
  skip_on_covr()

  x <- prior_only_recruit()
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x,
    niters = 0,
    allow_missing = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(nrow(fit$data), 0L)
})
