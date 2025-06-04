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

test_that("survival default works", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  fit <- bb_fit_survival(
    data = x, nthin = 1,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(coef(fit), "default")
})

test_that("fails with wrong prior", {
  x <- bboudata::bbousurv_a
  wrong_prior <- list(bInterce = 1)
  expect_chk_error(bb_fit_survival(x, nthin = 1L, priors = wrong_prior, quiet = TRUE), "Names in `priors` must match 'b0_mu', 'b0_sd', 'bAnnual_sd', 'bYear_mu', 'bYear_sd', 'sAnnual_rate' or 'sMonth_rate', not 'bInterce'.")
})

test_that("fails with multiple populations", {
  x <- rbind(bboudata::bbousurv_a, bboudata::bbousurv_b)
  expect_chk_error(bb_fit_survival(x, nthin = 1L, quiet = TRUE), "'PopulationName' can only contain one unique value.")
})

test_that("can set niters", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  niter <- 10L
  system.time({
    fit <- bb_fit_survival(
      data = x,
      nthin = 1,
      niters = niter,
      quiet = TRUE
    )
  })

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_identical(length(fit$samples$b0[1, , 1]), niter)
  expect_snapshot_data(coef(fit), "niters")
})
