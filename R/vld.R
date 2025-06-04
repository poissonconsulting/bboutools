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

.vld_sum_less <- function(x, colsum, coltot) {
  all(rowSums(x[colsum]) <= x[[coltot]])
}

.vld_fit <- function(x) {
  all(
    vld_s3_class(x, "bboufit"),
    vld_subset(names(x), c("model", "samples", "data", "model_code")),
    vld_true(all(names(attributes(x)) %in% c("names", "nthin", "model", "nobs", "niters", "year_trend", "year_start", "class"))),
    vld_s3_class(x$samples, "mcmcr")
  )
}

.vld_fit_ml <- function(x) {
  all(
    vld_s3_class(x, "bboufit_ml"),
    vld_subset(names(x), c("summary", "mle", "model", "data", "model_code")),
    vld_s4_class(x$summary, "AGHQuad_summary"),
    vld_s4_class(x$mle, "OptimResultNimbleList")
  )
}

.vld_population <- function(x) {
  length(unique(x$PopulationName)) == 1L
}

.vld_year_trend <- function(x) {
  attr(x, "year_trend")
}

.vld_year_start_equal <- function(survival, recruitment) {
  .year_start_bboufit(survival) == .year_start_bboufit(recruitment)
}
