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

test_that("bb_predict_growth works", {
  predict <- bb_predict_growth(bboutools:::fit_survival, bboutools:::fit_recruitment)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_growth")
})

test_that("bb_predict_growth warning when different year start", {
  survival <- fit_survival
  recruitment <- fit_recruitment
  .year_start_bboufit(survival) <- 5L
  expect_warning(bb_predict_growth(survival, recruitment))
})

test_that("bb_predict_growth works with sex ratio", {
  predict <- bb_predict_growth(bboutools:::fit_survival, bboutools:::fit_recruitment, sex_ratio = 0.7)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_growth_sex_ratio")
})

test_that("bb_predict_growth works with trend", {
  predict <- bb_predict_growth(bboutools:::fit_survival_trend, bboutools:::fit_recruitment_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_growth_trend")
})

test_that("bb_predict_growth conf_level works", {
  predict <- bb_predict_growth(bboutools:::fit_survival, bboutools:::fit_recruitment,
    conf_level = 0.5
  )
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_growth_conf_level")
})

test_that("bb_predict_growth estimate works", {
  predict <- bb_predict_growth(bboutools:::fit_survival, bboutools:::fit_recruitment,
    estimate = max
  )
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_growth_estimates")
})

test_that("bb_predict_growth multiple years each and one year common", {
  skip_on_covr()

  survival <- bboudata::bbousurv_a
  survival <- survival[survival$Year %in% 2002:2003, ]

  recruitment <- bboudata::bbourecruit_a
  recruitment <- recruitment[recruitment$Year %in% 2003:2004, ]

  set.seed(102)
  fit_survival <- bb_fit_survival(survival, quiet = TRUE, nthin = 1, year_start = 1L)
  set.seed(102)
  fit_recruitment <- bb_fit_recruitment(recruitment, quiet = TRUE, nthin = 1, year_start = 1L)

  predict <- bb_predict_growth(fit_survival, fit_recruitment)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_growth_one")
})

test_that("bb_predict_growth 1 year each and no years common", {
  skip_on_covr()

  survival <- bboudata::bbousurv_a
  survival <- survival[survival$Year %in% c(2002, 2004), ]

  recruitment <- bboudata::bbourecruit_a
  recruitment <- recruitment[recruitment$Year %in% c(2003, 2006), ]

  set.seed(102)
  fit_survival <- bb_fit_survival(survival, quiet = TRUE, nthin = 1, year_start = 1L)
  set.seed(102)
  fit_recruitment <- bb_fit_recruitment(recruitment, quiet = TRUE, nthin = 1, year_start = 1L)

  predict <- bb_predict_growth(fit_survival, fit_recruitment)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_growth_estimates_zero")
})

test_that("predict sig_fig works", {
  predict <- bb_predict_growth(bboutools:::fit_survival, bboutools:::fit_recruitment, sig_fig = 1)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_growth_sig_fig")
})

test_that("bb_predict_growth works with ML", {
  predict <- bb_predict_growth(bboutools:::fit_survival_ml, bboutools:::fit_recruitment_ml)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_growth_ml")
})
