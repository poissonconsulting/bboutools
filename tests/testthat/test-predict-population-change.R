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

test_that("bb_predict_population_change works", {
  predict <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_popchange")
})

test_that("bb_predict_population_change works with sex ratio", {
  predict <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment, sex_ratio = 0.7)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_popchange_sex_ratio")
})
test_that("bb_predict_population_change works with trend", {
  predict <- bb_predict_population_change(bboutools:::fit_survival_trend, bboutools:::fit_recruitment_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_popchange_trend")
})

test_that("bb_predict_population_change conf_level works", {
  predict <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment,
    conf_level = 0.5
  )
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_popchange_conf_level")
})

test_that("bb_predict_population_change estimate works", {
  predict <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment,
    estimate = max
  )
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_pophange_estimates")
})

test_that("predict sig_fig works", {
  predict <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment, sig_fig = 1)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_popchange_sig_fig")
})

test_that("bb_predict_population_change works with ML", {
  predict <- bb_predict_population_change(bboutools:::fit_survival_ml, bboutools:::fit_recruitment_ml)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_popchange_ml")
})
