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

test_that("national priors work with bb_fit_survival and change estimates", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  nat_priors <- bb_priors_survival_national(anthro = 80, fire_excl_anthro = 5)

  set.seed(101)
  fit_default <- bb_fit_survival(data = x, nthin = 1, quiet = TRUE)
  set.seed(101)
  fit_national <- bb_fit_survival(
    data = x,
    nthin = 1,
    priors = nat_priors,
    quiet = TRUE
  )

  expect_s3_class(fit_national, "bboufit")
  coef_default <- coef(fit_default)
  coef_national <- coef(fit_national)
  b0_default <- coef_default$estimate[coef_default$term == "b0"]
  b0_national <- coef_national$estimate[coef_national$term == "b0"]
  expect_false(identical(b0_default, b0_national))
})

test_that("national priors work with bb_fit_recruitment and change estimates", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  nat_priors <- bb_priors_recruitment_national(
    anthro = 80,
    fire_excl_anthro = 5
  )

  set.seed(101)
  fit_default <- bb_fit_recruitment(data = x, nthin = 10, quiet = TRUE)
  set.seed(101)
  fit_national <- bb_fit_recruitment(
    data = x,
    nthin = 10,
    priors = nat_priors,
    quiet = TRUE
  )

  expect_s3_class(fit_national, "bboufit")
  coef_default <- coef(fit_default)
  coef_national <- coef(fit_national)
  b0_default <- coef_default$estimate[coef_default$term == "b0"]
  b0_national <- coef_national$estimate[coef_national$term == "b0"]
  expect_false(identical(b0_default, b0_national))
})
