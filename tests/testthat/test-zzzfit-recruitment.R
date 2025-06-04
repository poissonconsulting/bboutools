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

test_that("recruitment default works", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x, nthin = 1,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_setequal(pars(fit), c("b0", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "default")
})

test_that("fails with wrong prior", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  wrong_prior <- list(bInterce = 1)
  expect_chk_error(bb_fit_recruitment(x, nthin = 1L, priors = wrong_prior, quiet = TRUE), "Names in `priors` must match 'adult_female_proportion_alpha', 'adult_female_proportion_beta', 'b0_mu', 'b0_sd', 'bAnnual_sd', 'bYear_mu', 'bYear_sd' or 'sAnnual_rate', not 'bInterce'.")
})

test_that("fails with multiple populations", {
  x <- rbind(bboudata::bbourecruit_a, bboudata::bbourecruit_b)
  expect_chk_error(bb_fit_recruitment(x, nthin = 1L, quiet = TRUE), "'PopulationName' can only contain one unique value.")
})
