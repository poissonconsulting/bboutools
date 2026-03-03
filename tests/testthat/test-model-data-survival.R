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

test_that("prep model data with multi population", {
  x <- bboudata::bbousurv_multi
  x2 <- model_data_survival(
    x,
    include_uncertain_morts = TRUE,
    year_start = 4L,
    quiet = TRUE
  )

  expect_identical(x2$datal$nAnnual, 15L)
  expect_identical(x2$datal$nPopulation, 3L)
  expect_identical(x2$datal$nMonth, 12L)
})

test_that("data annual", {
  x <- bboudata::bbousurv_annual
  x2 <- model_data_survival(
    x,
    include_uncertain_morts = TRUE,
    year_start = 4L,
    quiet = TRUE
  )

  expect_identical(x2$datal$nAnnual, 12L)
  expect_identical(x2$datal$nPopulation, 2L)
  expect_identical(x2$datal$nMonth, 1L)
})

test_that("data annual single pop", {
  x <- bboudata::bbousurv_annual
  x <- x[x$PopulationName == "C", ]
  x2 <- model_data_survival(
    x,
    include_uncertain_morts = TRUE,
    year_start = 4L,
    quiet = TRUE
  )

  expect_identical(x2$datal$nAnnual, 9L)
  expect_identical(x2$datal$nPopulation, 1L)
  expect_identical(x2$datal$nMonth, 1L)
})

test_that("allow_missing single pop", {
  x <- bboudata::bbousurv_missing
  x2 <- model_data_survival(
    x,
    include_uncertain_morts = TRUE,
    year_start = 4L,
    allow_missing = TRUE,
    quiet = TRUE
  )

  # nAnnual includes unobserved years
  expect_gt(x2$datal$nAnnual, x2$nAnnualObserved)
  # nObs excludes placeholder rows
  expect_identical(x2$datal$nObs, nrow(x2$data))
  expect_true(all(!is.na(x2$data$Month)))
  # Annual factor levels include unobserved years
  expect_identical(x2$datal$nAnnual, length(levels(x2$data$Annual)))
})

test_that("allow_missing multi pop", {
  x <- bboudata::bbousurv_multi
  x2 <- model_data_survival(
    x,
    include_uncertain_morts = TRUE,
    year_start = 4L,
    allow_missing = TRUE,
    quiet = TRUE
  )

  # nAnnual includes unobserved year (2015)
  expect_gt(x2$datal$nAnnual, x2$nAnnualObserved)
  expect_identical(x2$datal$nObs, nrow(x2$data))
  expect_true(all(!is.na(x2$data$Month)))
  expect_identical(x2$datal$nPopulation, 3L)
})
