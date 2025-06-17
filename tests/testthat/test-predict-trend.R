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

test_that("bb_predict_survival_trend works", {
  predict <- bb_predict_survival_trend(bboutools:::fit_survival_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend_trend")
})

test_that("bb_predict_survival_trend fails if no year trend fit", {
  expect_chk_error(bb_predict_survival_trend(bboutools:::fit_survival))
})

test_that("bb_predict_survival_trend works with ML", {
  predict <- bb_predict_survival_trend(bboutools:::fit_survival_ml_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend_trend_ml")
})

test_that("bb_predict_survival_trend fails if no year trend fit with ML", {
  expect_chk_error(bb_predict_survival_trend(bboutools:::fit_survival_ml))
})

test_that("bb_predict_recruitment_trend works", {
  predict <- bb_predict_recruitment_trend(bboutools:::fit_recruitment_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment_trend_trend")
})

test_that("bb_predict_recruitment_trend fails if no year trend fit", {
  expect_chk_error(bb_predict_recruitment_trend(bboutools:::fit_recruitment))
})

test_that("bb_predict_recruitment_trend works with ML", {
  predict <- bb_predict_recruitment_trend(bboutools:::fit_recruitment_ml_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment_trend_trend_ml")
})

test_that("bb_predict_recruitment_trend fails if no year trend fit", {
  expect_chk_error(bb_predict_recruitment_trend(bboutools:::fit_recruitment_ml))
})

test_that("bb_predict_calf_cow_ratio_trend works", {
  predict <- bb_predict_calf_cow_ratio_trend(bboutools:::fit_recruitment_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_calf_cow_ratio_trend_trend")
})

test_that("bb_predict_calf_cow_ratio_trend fails if no year trend fit", {
  expect_chk_error(bb_predict_calf_cow_ratio_trend(bboutools:::fit_recruitment))
})

test_that("bb_predict_calf_cow_ratio_trend works with ML", {
  predict <- bb_predict_calf_cow_ratio_trend(bboutools:::fit_recruitment_ml_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_calf_cow_ratio_trend_trend_ml")
})

test_that("bb_predict_calf_cow_ratio_trend fails if no year trend fit", {
  expect_chk_error(bb_predict_calf_cow_ratio_trend(bboutools:::fit_recruitment_ml))
})
