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

test_that("bb_plot_year_trend_recruitment.bboufit_recruitment works", {
  plot <- bb_plot_year_trend_recruitment(bboutools:::fit_recruitment_trend)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_recruitment")
})

test_that("bb_plot_year_trend_recruitment.data.frame works", {
  prediction <- bb_predict_recruitment_trend(bboutools:::fit_recruitment_trend)
  plot <- bb_plot_year_trend_recruitment(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_recruitment_df")
})

test_that("bb_plot_year_trend_recruitment.bboufit_recruitment ML works", {
  plot <- bb_plot_year_trend_recruitment(bboutools:::fit_recruitment_ml_trend)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_recruitment_ml")
})

test_that("bb_plot_year_trend_recruitment.data.frame ML works", {
  prediction <- bb_predict_recruitment_trend(bboutools:::fit_recruitment_ml_trend)
  plot <- bb_plot_year_trend_recruitment(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_recruitment_ml_df")
})

test_that("bb_plot_year_trend_recruitment.data.frame no rows", {
  prediction <- tibble::tribble(
    ~CaribouYear, ~estimate, ~lower, ~upper,
    1L, 0.5, 0.4, 0.6
  )
  
  prediction <- prediction[-1, ]
  
  plot <- bb_plot_year_trend_recruitment(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_0")
})
