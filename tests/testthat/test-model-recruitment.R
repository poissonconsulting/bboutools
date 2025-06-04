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

test_that("recruitment fixed model works", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  x <- data_prep_recruitment(x)
  x <- data_list_recruitment(x)
  model <- model_recruitment(
    data = x,
    year_random = FALSE,
    priors = priors_recruitment()
  )

  expect_snapshot_data(code_to_df(model$getCode()), "fixed_code")
  expect_snapshot_data(vars_to_df(model$getConstants()), "fixed_const")
})

test_that("can change fixed adult_female_proportion", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  x <- data_prep_recruitment(x)
  x <- data_list_recruitment(x)
  prop <- 0.5
  model <- model_recruitment(
    data = x,
    adult_female_proportion = prop,
    priors = priors_recruitment()
  )

  const <- model$getConstants()
  expect_identical(const$adult_female_prop, prop)
  expect_snapshot_data(code_to_df(model$getCode()), "female_prop_code")
  expect_snapshot_data(vars_to_df(const), "female_prop_const")
})

test_that("can change fixed sex_ratio", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  x$Yearlings[5:10] <- 1
  x <- data_prep_recruitment(x)
  x <- data_list_recruitment(x)
  sr <- 0.2
  model <- model_recruitment(
    data = x,
    sex_ratio = sr,
    priors = priors_recruitment()
  )

  const <- model$getConstants()
  expect_identical(const$sex_ratio, sr)
  expect_snapshot_data(code_to_df(model$getCode()), "sex_ratio_code")
  expect_snapshot_data(vars_to_df(const), "sex_ratio_const")
})

test_that("can estimate adult_female_proportion", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  x <- data_prep_recruitment(x)
  x <- data_list_recruitment(x)
  model <- model_recruitment(
    data = x,
    adult_female_proportion = NULL,
    priors = priors_recruitment()
  )

  const <- model$getConstants()
  expect_snapshot_data(code_to_df(model$getCode()), "est_female_prop_code")
  expect_snapshot_data(vars_to_df(const), "est_female_prop_const")
})

test_that("recruitment can set caribou year", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  x <- data_prep_recruitment(x, year_start = 3L)
  x <- data_list_recruitment(x)
  model <- model_recruitment(data = x, priors = priors_recruitment())

  const <- model$getConstants()
  expect_snapshot_data(code_to_df(model$getCode()), "caribou_year_code")
  expect_snapshot_data(vars_to_df(const), "caribou_year_const")
})

test_that("recruitment trend works", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  x <- data_prep_recruitment(x)
  x <- data_list_recruitment(x)
  model <- model_recruitment(
    data = x,
    year_random = TRUE,
    year_trend = TRUE,
    priors = priors_recruitment()
  )

  const <- model$getConstants()
  expect_snapshot_data(code_to_df(model$getCode()), "trend_code")
  expect_snapshot_data(vars_to_df(const), "trend_const")
})

test_that("recruitment trend_only works", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  x <- data_prep_recruitment(x)
  x <- data_list_recruitment(x)
  model <- model_recruitment(
    data = x,
    year_random = FALSE,
    year_trend = TRUE,
    priors = priors_recruitment()
  )

  const <- model$getConstants()
  expect_snapshot_data(code_to_df(model$getCode()), "trend_only_code")
  expect_snapshot_data(vars_to_df(const), "trend_only_const")
})

test_that("can set priors", {
  skip_on_covr()

  set.seed(101)
  mu <- 20
  priors <- c(b0_mu = mu, b0_sd = 0.5)
  priors <- replace_priors(priors_recruitment(), priors)
  x <- bboudata::bbourecruit_a
  x <- data_prep_recruitment(x)
  x <- data_list_recruitment(x)
  model <- model_recruitment(
    data = x,
    priors = priors
  )
  const <- model$getConstants()
  # not 31 as per usual
  expect_identical(mu, const$b0_mu)
  expect_snapshot_data(code_to_df(model$getCode()), "priors_code")
  expect_snapshot_data(vars_to_df(const), "priors_const")
})
