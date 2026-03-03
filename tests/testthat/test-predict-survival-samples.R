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

test_that("bb_predict_survival_samples works", {
  predict <- bb_predict_survival_samples(bboutools:::fit_survival)
  expect_type(predict, "list")
  expect_named(predict, c("samples", "data"))
  expect_s3_class(predict$samples, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$samples >= 0 & predict$samples <= 1))
})

test_that("bb_predict_survival_samples month works", {
  predict <- bb_predict_survival_samples(
    bboutools:::fit_survival,
    year = FALSE,
    month = TRUE
  )
  expect_type(predict, "list")
  expect_named(predict, c("samples", "data"))
  expect_s3_class(predict$samples, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$samples >= 0 & predict$samples <= 1))
})

test_that("bb_predict_survival_samples month year works", {
  predict <- bb_predict_survival_samples(
    bboutools:::fit_survival,
    year = TRUE,
    month = TRUE
  )
  expect_type(predict, "list")
  expect_named(predict, c("samples", "data"))
  expect_s3_class(predict$samples, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$samples >= 0 & predict$samples <= 1))
})

test_that("bb_predict_survival_samples one works", {
  predict <- bb_predict_survival_samples(
    bboutools:::fit_survival,
    year = FALSE,
    month = FALSE
  )
  expect_type(predict, "list")
  expect_named(predict, c("samples", "data"))
  expect_s3_class(predict$samples, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$samples >= 0 & predict$samples <= 1))
})

test_that("bb_predict_survival_samples on fit with trend works", {
  predict <- bb_predict_survival_samples(bboutools:::fit_survival_trend)
  expect_type(predict, "list")
  expect_named(predict, c("samples", "data"))
  expect_s3_class(predict$samples, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$samples >= 0 & predict$samples <= 1))
})

test_that("bb_predict_survival_samples works on ML", {
  predict <- bb_predict_survival_samples(bboutools:::fit_survival_ml)
  expect_type(predict, "list")
  expect_named(predict, c("samples", "data"))
  expect_s3_class(predict$samples, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$samples >= 0 & predict$samples <= 1))
})

test_that("bb_predict_survival_samples works on ML with fixed", {
  predict <- bb_predict_survival_samples(bboutools:::fit_survival_ml_fixed)
  expect_type(predict, "list")
  expect_named(predict, c("samples", "data"))
  expect_s3_class(predict$samples, "mcmcarray")
  expect_s3_class(predict$data, "data.frame")
  expect_true(all(predict$samples >= 0 & predict$samples <= 1))
})
