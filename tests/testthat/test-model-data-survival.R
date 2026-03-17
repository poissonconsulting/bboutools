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

test_that("allow_missing with no placeholders single pop", {
  x <- bboudata::bbousurv_a
  x2 <- model_data_survival(
    x,
    include_uncertain_morts = TRUE,
    year_start = 4L,
    allow_missing = TRUE,
    quiet = TRUE
  )

  # no unobserved years so nAnnual equals nAnnualObserved
  expect_identical(x2$datal$nAnnual, x2$nAnnualObserved)
  expect_identical(x2$datal$nPopulation, 1L)
})

test_that("allow_missing with no placeholders multi pop", {
  x <- bboudata::bbousurv_multi[!is.na(bboudata::bbousurv_multi$Month), ]
  x2 <- model_data_survival(
    x,
    include_uncertain_morts = TRUE,
    year_start = 4L,
    allow_missing = TRUE,
    quiet = TRUE
  )

  expect_identical(x2$datal$nAnnual, x2$nAnnualObserved)
  expect_identical(x2$datal$nPopulation, 3L)
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

test_that("placeholder detected by measurement columns not Month", {
  x <- bboudata::bbousurv_a
  # add a row with valid Month but all-NA measurements

  placeholder <- x[1, ]
  placeholder$Year <- 2099L
  placeholder$Month <- 4L
  placeholder$StartTotal <- NA_integer_
  placeholder$MortalitiesCertain <- NA_integer_
  placeholder$MortalitiesUncertain <- NA_integer_
  x2 <- rbind(x, placeholder)

  result <- model_data_survival(
    x2,
    include_uncertain_morts = TRUE,
    year_start = 4L,
    allow_missing = TRUE,
    quiet = TRUE
  )

  # placeholder row should be detected and excluded from data
  expect_false(2099L %in% result$data$Year)
  # but the unobserved year should be in the Annual factor levels
  expect_gt(result$datal$nAnnual, result$nAnnualObserved)
})

test_that("message emitted for unobserved years when quiet = FALSE", {
  x <- bboudata::bbousurv_missing
  expect_message(
    model_data_survival(
      x,
      include_uncertain_morts = TRUE,
      year_start = 4L,
      allow_missing = TRUE,
      quiet = FALSE
    ),
    "Detected unobserved CaribouYear"
  )
})

test_that("no message for unobserved years when quiet = TRUE", {
  x <- bboudata::bbousurv_missing
  expect_silent(
    model_data_survival(
      x,
      include_uncertain_morts = TRUE,
      year_start = 4L,
      allow_missing = TRUE,
      quiet = TRUE
    )
  )
})
