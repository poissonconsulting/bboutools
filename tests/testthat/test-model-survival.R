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

test_that("survival fixed model works", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  x <- data_prep_survival(x)
  x <- data_list_survival(x)
  model <- model_survival(
    data = x,
    year_random = FALSE,
    priors = priors_survival()
  )

  expect_snapshot_data(code_to_df(model$getCode()), "fixed_code")
  expect_snapshot_data(vars_to_df(model$getConstants()), "fixed_const")
})

test_that("works with less than 12 months", {
  skip_on_covr()
  skip_on_os("windows")

  x <- bboudata::bbousurv_a
  x <- x[!x$Month %in% 12, ]
  x <- data_prep_survival(x)
  x <- data_list_survival(x)
  model <- model_survival(
    data = x,
    year_random = FALSE,
    priors = priors_survival()
  )

  const <- model$getConstants()
  expect_identical(const$nMonth, 11L)
  expect_snapshot_data(code_to_df(model$getCode()), "less_than_12_months_code")
  expect_snapshot_data(vars_to_df(const), "less_than_12_months_const")
})

test_that("year trend works", {
  skip_on_covr()
  skip_on_os("windows")

  x <- bboudata::bbousurv_a
  x <- data_prep_survival(x)
  x <- data_list_survival(x)
  model <- model_survival(
    data = x,
    year_random = TRUE,
    year_trend = TRUE,
    priors = priors_survival()
  )

  expect_snapshot_data(code_to_df(model$getCode()), "trend_code")
  expect_snapshot_data(vars_to_df(model$getConstants()), "trend_const")
})

test_that("year trend only works", {
  skip_on_covr()
  skip_on_os("windows")

  x <- bboudata::bbousurv_a
  x <- data_prep_survival(x)
  x <- data_list_survival(x)
  model <- model_survival(
    data = x,
    year_random = FALSE,
    year_trend = TRUE,
    priors = priors_survival()
  )

  expect_snapshot_data(code_to_df(model$getCode()), "trend_only_code")
  expect_snapshot_data(vars_to_df(model$getConstants()), "trend_only_const")
})

test_that("can include_uncertain_morts", {
  skip_on_covr()

  set.seed(101)
  x <- bboudata::bbousurv_a
  x$MortalitiesUncertain <- pmin(x$StartTotal - x$MortalitiesCertain, rbinom(nrow(x), prob = 0.1, size = 1))
  x <- data_prep_survival(x)
  x <- data_list_survival(x)
  model <- model_survival(
    data = x,
    year_random = TRUE,
    priors = priors_survival()
  )

  expect_snapshot_data(code_to_df(model$getCode()), "uncertain_morts_code")
  expect_snapshot_data(vars_to_df(model$getConstants()), "uncertain_morts_const")
  expect_snapshot_data(data.frame(morts = model$Mortalities), "uncertain_morts_morts")
})

test_that("survival year start works", {
  skip_on_covr()

  set.seed(101)
  x <- bboudata::bbousurv_a
  x <- data_prep_survival(x, year_start = 3L)
  x <- data_list_survival(x)
  model <- model_survival(
    data = x,
    year_random = TRUE,
    priors = priors_survival()
  )
  const <- model$getConstants()
  # not 31 years as per default
  expect_identical(32L, const$nAnnual)
  expect_snapshot_data(code_to_df(model$getCode()), "year_start_code")
  expect_snapshot_data(vars_to_df(const), "year_start_const")
})

test_that("can set priors", {
  skip_on_covr()

  set.seed(101)
  mu <- 20
  priors <- c(b0_mu = mu, b0_sd = 0.5)
  priors <- replace_priors(priors_survival(), priors)
  x <- bboudata::bbousurv_a
  x <- data_prep_survival(x)
  x <- data_list_survival(x)
  model <- model_survival(
    data = x,
    year_random = TRUE,
    priors = priors
  )
  const <- model$getConstants()
  # not 31 as per usual
  expect_identical(mu, const$b0_mu)
  expect_snapshot_data(code_to_df(model$getCode()), "priors_code")
  expect_snapshot_data(vars_to_df(const), "priors_const")
})
