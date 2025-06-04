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

test_that("survival ml works", {
  skip_on_covr()
  skip_on_os("windows")

  inits <- list(
    b0 = 5,
    sAnnual = 0.2,
    sMonth = 0.2
  )

  x <- bboudata::bbousurv_a
  fit <- bb_fit_survival_ml(
    data = x,
    inits = inits,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bAnnual", "bMonth", "sAnnual", "sMonth"))
  expect_snapshot_data(coef(fit), "default")
})

test_that("fails with multiple populations", {
  x <- rbind(bboudata::bbousurv_a, bboudata::bbousurv_b)
  expect_chk_error(bb_fit_survival_ml(x, quiet = TRUE), "'PopulationName' can only contain one unique value.")
})
