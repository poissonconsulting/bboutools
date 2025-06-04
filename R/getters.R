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

`.nthin_bboufit<-` <- function(fit, value) {
  attr(fit, "nthin") <- value
  fit
}

.nthin_bboufit <- function(fit) {
  attr(fit, "nthin", exact = TRUE)
}

`.niters_bboufit<-` <- function(fit, value) {
  attr(fit, "niters") <- value
  fit
}

.niters_bboufit <- function(fit) {
  attr(fit, "niters", exact = TRUE)
}

`.nobs_bboufit<-` <- function(fit, value) {
  attr(fit, "nobs") <- value
  fit
}

.nobs_bboufit <- function(fit) {
  attr(fit, "nobs", exact = TRUE)
}

`.converged_bboufit<-` <- function(fit, value) {
  attr(fit, "converged") <- value
  fit
}

.converged_bboufit <- function(fit) {
  attr(fit, "converged", exact = TRUE)
}

`.year_trend_bboufit<-` <- function(fit, value) {
  attr(fit, "year_trend") <- value
  fit
}

.year_trend_bboufit <- function(fit) {
  attr(fit, "year_trend", exact = TRUE)
}

`.year_start_bboufit<-` <- function(fit, value) {
  attr(fit, "year_start") <- value
  fit
}

.year_start_bboufit <- function(fit) {
  attr(fit, "year_start", exact = TRUE)
}

.attrs_bboufit <- function(fit) {
  attrs <- attributes(fit)
  attrs[c("nthin", "nobs", "niters", "year_trend", "year_start")]
}

.attrs_bboufit_ml <- function(fit) {
  attrs <- attributes(fit)
  attrs[c("nobs", "converged", "year_trend", "year_start")]
}

`.attrs_bboufit<-` <- function(fit, value) {
  .nthin_bboufit(fit) <- value$nthin
  .niters_bboufit(fit) <- value$niters
  .nobs_bboufit(fit) <- value$nobs
  .year_trend_bboufit(fit) <- value$year_trend
  .year_start_bboufit(fit) <- value$year_start
  fit
}

`.attrs_bboufit_ml<-` <- function(fit, value) {
  .converged_bboufit(fit) <- value$converged
  .nobs_bboufit(fit) <- value$nobs
  .year_trend_bboufit(fit) <- value$year_trend
  .year_start_bboufit(fit) <- value$year_start
  fit
}
