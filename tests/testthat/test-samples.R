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

test_that("sample works for bboutfit", {
  x <- samples(fit_recruitment)
  expect_s3_class(x, "mcmcr")
  expect_equal(nchains(x), 3)
  expect_equal(niters(x), 1000)
})

test_that("sample works for bboutfit_ml", {
  x <- samples(fit_recruitment_ml)
  expect_s3_class(x, "mcmcr")
  expect_equal(nchains(x), 1)
  expect_equal(niters(x), 1)
})
