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

test_that("bb_predict_calf_cow_ratio works", {
  predict <- bb_predict_calf_cow_ratio(bboutools:::fit_recruitment)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_calf_cow")
})

test_that("bb_predict_calf_cow on fit with trend works", {
  predict <- bb_predict_calf_cow_ratio(bboutools:::fit_recruitment_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment_trend")
})

test_that("bb_predict_calf_cow works on ML", {
  predict <- bb_predict_calf_cow_ratio(bboutools:::fit_recruitment_ml)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_calf_cow_ml")
})

test_that("bb_predict_calf_cow works on fixed ML", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment_ml_fixed)
  expect_true(all(!is.na(predict$estimate)))
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_calf_cow_ml_fixed")
})

test_that("bb_predict_recruitment works on ML with trend", {
  predict <- bb_predict_calf_cow_ratio(bboutools:::fit_recruitment_ml_trend)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_calf_cow_ml_trend")
})
