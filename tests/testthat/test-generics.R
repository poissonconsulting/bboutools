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

test_that("glance works", {
  glance <- glance(bboutools:::fit_survival)
  expect_s3_class(glance, "tbl")
  expect_snapshot_data(glance, "glance")
})

test_that("glance ml works", {
  glance_ml <- glance(bboutools:::fit_survival_ml)
  expect_s3_class(glance_ml, "tbl")
  expect_snapshot_data(glance_ml, "glance_ml")
})

test_that("glance rhat works", {
  glance <- glance(bboutools:::fit_survival, rhat = 1.001)
  expect_false(glance$converged)
})

test_that("augment works", {
  augment <- augment(bboutools:::fit_survival)
  expect_s3_class(augment, "tbl")
  expect_snapshot_data(augment, "augment")
})

test_that("augment ml works", {
  augment <- augment(bboutools:::fit_survival_ml)
  expect_s3_class(augment, "tbl")
  expect_snapshot_data(augment, "augment_ml")
})

test_that("tidy works", {
  tidy <- tidy(bboutools:::fit_recruitment)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "tidy")
})

test_that("tidy ml works", {
  tidy <- tidy(bboutools:::fit_recruitment_ml)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "tidy_ml")
})

test_that("coef works and same as tidy", {
  expect_identical(
    coef(bboutools:::fit_recruitment),
    tidy(bboutools:::fit_recruitment)
  )
})

test_that("coef ml works and same as tidy ml", {
  expect_identical(
    coef(bboutools:::fit_recruitment_ml),
    tidy(bboutools:::fit_recruitment_ml)
  )
})

test_that("tidy conf level works", {
  tidy <- tidy(bboutools:::fit_recruitment, conf_level = 0.5)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "conf_level")
})

test_that("tidy ml conf level works", {
  tidy <- tidy(bboutools:::fit_recruitment_ml, conf_level = 0.5)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "conf_level_ml")
})

test_that("tidy sig fig works", {
  tidy <- tidy(bboutools:::fit_recruitment, sig_fig = 1)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "sig_fig")
})

test_that("tidy ml sig fig works", {
  tidy <- tidy(bboutools:::fit_recruitment_ml, sig_fig = 1)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "sig_fig_ml")
})

test_that("tidy estimate works", {
  tidy <- tidy(bboutools:::fit_recruitment, estimate = mean)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "estimate")
})

test_that("summary estimate works", {
  summary <- summary(bboutools:::fit_survival, estimate = mean)
  expect_snapshot(summary)
})

test_that("summary ml works", {
  summary_ml <- summary(bboutools:::fit_survival_ml)
  expect_snapshot(summary_ml)
})

test_that("summary ml matches estimates correctly", {
  x <- summary(bboutools:::fit_survival_ml_fixed)
  x <- x$bAnnual[2]
  expect_equal(bboutools:::fit_survival_ml_fixed$summary$params$estimate[2], x)
})

test_that("estimate works", {
  estimates <- estimates(bboutools:::fit_recruitment)
  expect_snapshot(estimates)
})

test_that("estimate ml works", {
  estimates_ml <- estimates(bboutools:::fit_recruitment_ml)
  expect_snapshot(estimates_ml)
})

test_that("get attributes works", {
  expect_identical(npars(bboutools:::fit_survival), 5L)
  expect_identical(niters(bboutools:::fit_survival), 1000L)
  expect_identical(nobs(bboutools:::fit_survival), 363L)
  expect_identical(nchains(bboutools:::fit_survival), 3L)
  expect_identical(nterms(bboutools:::fit_recruitment), 29L)
  expect_identical(pars(bboutools:::fit_recruitment), c("b0", "bAnnual", "sAnnual"))
})

test_that("get attributes ml works", {
  expect_identical(npars(bboutools:::fit_survival_ml), 5L)
  expect_identical(nobs(bboutools:::fit_survival_ml), 363L)
  expect_identical(nterms(bboutools:::fit_recruitment_ml), 29L)
  expect_identical(pars(bboutools:::fit_recruitment_ml), c("b0", "bAnnual", "sAnnual"))
})

test_that("convergence works", {
  expect_equal(rhat(bboutools:::fit_survival), 1.024)
  expect_true(converged(bboutools:::fit_survival))
  expect_equal(esr(bboutools:::fit_survival), 0.034)
})
