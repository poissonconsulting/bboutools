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
  x <- bboudata::bbourecruit_multi
  x2 <- model_data_recruitment(x, year_start = 4L, quiet = TRUE)

  expect_identical(x2$datal$nPopulation, 3L)
  expect_identical(x2$datal$nAnnual, 13L)
  expect_true(x2$datal$nObs > 0L)
})

test_that("prep model data with single population", {
  x <- bboudata::bbourecruit_a
  x2 <- model_data_recruitment(x, year_start = 4L, quiet = TRUE)

  expect_identical(x2$datal$nPopulation, 1L)
  expect_true(x2$datal$nAnnual > 0L)
  expect_true(x2$datal$nObs > 0L)
})
