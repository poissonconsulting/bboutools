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

test_that("plot_year_survival.survival works", {
  plot <- bb_plot_year_survival(bboutools:::fit_survival)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_survival_survival")
})

test_that("plot_year_survival.data.frame works", {
  prediction <- predict(bboutools:::fit_survival)
  plot <- bb_plot_year_survival(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_survival_predict_survival")
})

test_that("plot_year_survival.survival ML works", {
  plot <- bb_plot_year_survival(bboutools:::fit_survival_ml)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_survival_survival_ml")
})

test_that("plot_year_survival.data.frame ML works", {
  prediction <- predict(bboutools:::fit_survival_ml)
  plot <- bb_plot_year_survival(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_survival_predict_survival_ml")
})
