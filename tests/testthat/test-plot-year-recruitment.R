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

test_that("plot_year_recruitment.recruitment works", {
  plot <- bb_plot_year_recruitment(bboutools:::fit_recruitment)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "recruitment")
})

test_that("plot_year_recruitment.data.frame works", {
  prediction <- predict(bboutools:::fit_recruitment)
  plot <- bb_plot_year_recruitment(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "dataframe")
})

test_that("plot_year_recruitment.recruitment ML works", {
  plot <- bb_plot_year_recruitment(bboutools:::fit_recruitment_ml)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "recruitment_ml")
})

test_that("plot_year_recruitment.data.frame ML works", {
  prediction <- predict(bboutools:::fit_recruitment_ml)
  plot <- bb_plot_year_recruitment(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "dataframe_ml")
})
