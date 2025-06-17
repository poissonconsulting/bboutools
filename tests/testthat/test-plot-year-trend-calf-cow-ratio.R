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

test_that("bb_plot_year_trend_calf_cow_ratio.bboufit_recruitment works", {
  plot <- bb_plot_year_trend_calf_cow_ratio(bboutools:::fit_recruitment_trend)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_calf_cow_ratio")
})

test_that("bb_plot_year_trend_calf_cow_ratio.data.frame works", {
  prediction <- bb_predict_calf_cow_ratio_trend(bboutools:::fit_recruitment_trend)
  plot <- bb_plot_year_trend_calf_cow_ratio(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_calf_cow_ratio_df")
})
