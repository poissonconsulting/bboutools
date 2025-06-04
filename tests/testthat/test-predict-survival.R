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

test_that("bb_predict_survival works", {
  predict <- bb_predict_survival(bboutools:::fit_survival)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_survival")
})

test_that("bb_predict_survival month works", {
  predict <- bb_predict_survival(bboutools:::fit_survival, year = FALSE, month = TRUE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_month")
})

test_that("bb_predict_survival month year works", {
  predict <- bb_predict_survival(bboutools:::fit_survival, year = TRUE, month = TRUE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_month_year")
})

test_that("bb_predict_survival one works", {
  predict <- bb_predict_survival(bboutools:::fit_survival, year = FALSE, month = FALSE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_1")
})

test_that("bb_predict_survival on fit with trend works", {
  predict <- bb_predict_survival(bboutools:::fit_survival_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend")
})

test_that("bb_predict_survival on fit with trend, month works", {
  predict <- bb_predict_survival(bboutools:::fit_survival_trend, year = FALSE, month = TRUE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend_month")
})

test_that("bb_predict_survival on fit with trend, month and year works", {
  predict <- bb_predict_survival(bboutools:::fit_survival_trend, year = TRUE, month = TRUE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend_month_year")
})

test_that("bb_predict_survival on fit with trend one works", {
  predict <- bb_predict_survival(bboutools:::fit_survival_trend, year = FALSE, month = FALSE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend_1")
})

test_that("bb_predict_survival conf_level works", {
  predict <- bb_predict_survival(bboutools:::fit_survival,
    year = FALSE, month = FALSE,
    conf_level = 0.5
  )
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_conf_level")
})

test_that("bb_predict_survival estimate works", {
  predict <- bb_predict_survival(bboutools:::fit_survival,
    year = FALSE, month = FALSE,
    estimate = max
  )
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_survival_estimates")
})

test_that("generic predict survival works", {
  predict <- predict(bboutools:::fit_survival)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "predict_survival")
})

test_that("predict sig_fig works", {
  predict <- predict(bboutools:::fit_survival, sig_fig = 1)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "predict_survival_sig_fig")
})

test_that("bb_predict_survival works on ML", {
  predict <- bb_predict_survival(bboutools:::fit_survival_ml)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_survival_ml")
})

test_that("bb_predict_survival works on ML with fixed", {
  predict <- bb_predict_survival(bboutools:::fit_survival_ml_fixed)
  expect_true(all(!is.na(predict$estimate)))
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_survival_ml_fixed")
})

test_that("bb_predict_survival works on ML with trend", {
  predict <- bb_predict_survival(bboutools:::fit_survival_ml_trend)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_survival_ml_trend")
})

test_that("generic predict survival works on ML", {
  predict <- predict(bboutools:::fit_survival_ml)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "predict_survival_ml")
})
