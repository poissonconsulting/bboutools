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

test_that("bb_predict_growth_samples works", {
  predict <- bb_predict_growth_samples(
    bboutools:::fit_survival,
    bboutools:::fit_recruitment
  )
  expect_type(predict, "list")
  expect_named(predict, c("lambda", "data"))
  expect_s3_class(predict$lambda, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$lambda >= 0))
})

test_that("bb_predict_growth_samples works with sex ratio", {
  predict <- bb_predict_growth_samples(
    bboutools:::fit_survival,
    bboutools:::fit_recruitment,
    sex_ratio = 0.7
  )
  expect_type(predict, "list")
  expect_named(predict, c("lambda", "data"))
  expect_s3_class(predict$lambda, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$lambda >= 0))
})

test_that("bb_predict_growth_samples works with trend", {
  predict <- bb_predict_growth_samples(
    bboutools:::fit_survival_trend,
    bboutools:::fit_recruitment_trend
  )
  expect_type(predict, "list")
  expect_named(predict, c("lambda", "data"))
  expect_s3_class(predict$lambda, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$lambda >= 0))
})

test_that("bb_predict_growth_samples works with ML", {
  predict <- bb_predict_growth_samples(
    bboutools:::fit_survival_ml,
    bboutools:::fit_recruitment_ml
  )
  expect_type(predict, "list")
  expect_named(predict, c("lambda", "data"))
  expect_s3_class(predict$lambda, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$lambda >= 0))
})
