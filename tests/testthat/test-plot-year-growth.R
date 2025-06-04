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

test_that("bb_plot_year_growth works", {
  prediction <- bb_predict_growth(bboutools:::fit_survival, bboutools:::fit_recruitment)
  plot <- bb_plot_year_growth(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_growth")
})

test_that("bb_plot_year_population_change works", {
  prediction <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment)
  plot <- bb_plot_year_population_change(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_population_change")
})

test_that("bb_plot_year_growth ML works", {
  prediction <- bb_predict_growth(bboutools:::fit_survival_ml, bboutools:::fit_recruitment_ml)
  plot <- bb_plot_year_growth(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_growth_ml")
})

test_that("bb_plot_year_population_change ML works", {
  prediction <- bb_predict_population_change(bboutools:::fit_survival_ml, bboutools:::fit_recruitment_ml)
  plot <- bb_plot_year_population_change(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_population_change_ml")
})
