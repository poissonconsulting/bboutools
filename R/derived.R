# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
# Copyright 2024 Province of Alberta
# Copyright (c) His Majesty the King in Right of Canada as represented by the
# Minister of the Environment 2025/(c) Sa Majeste le Roi du chef du Canada
# representee par le ministre de l'Environnement 2025.
# (Multi-population derived expressions and annual data handling
# borrowed from ECCC implementation in LandSciTech/bboutoolsMultiPop.)
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

extract_lik <- function(x) {
  if (inherits(x, "bboufit_survival")) {
    "b0[PopulationName[i]] + bAnnual[Annual[i], PopulationName[i]] + bYear[PopulationName[i]] * CaribouYear[i] + bMonth[Month[i], PopulationName[i]]"
  } else {
    "b0[PopulationName[i]] + bAnnual[Annual[i], PopulationName[i]] + bYear[PopulationName[i]] * CaribouYear[i]"
  }
}

extract_lik_year <- function(x) {
  "b0[PopulationName[i]] + bAnnual[Annual[i], PopulationName[i]] + bYear[PopulationName[i]] * CaribouYear[i]"
}

derived_expr_survival <- function(fit, year, month) {
  lik_year <- extract_lik_year(fit)
  if (year) {
    if (month) {
      pred <- paste0(
        "logit(ilogit(",
        lik_year,
        " + bMonth[Month[i], PopulationName[i]])^12)"
      )
    } else {
      if (length(levels(fit$data$Month)) > 1) {
        pred <- paste0("logit(ilogit(", lik_year, ")^12)")
      } else {
        pred <- paste0("logit(ilogit(", lik_year, "))")
      }
    }
  } else {
    if (month) {
      pred <- "logit(ilogit(b0[PopulationName[i]] + bMonth[Month[i], PopulationName[i]])^12)"
    } else {
      if (length(levels(fit$data$Month)) > 1) {
        pred <- "logit(ilogit(b0[PopulationName[i]])^12)"
      } else {
        pred <- "logit(ilogit(b0[PopulationName[i]]))"
      }
    }
  }
  paste0(
    "for(i in 1:length(Annual)) {
  logit(prediction[i]) <- ",
    pred,
    "\n}"
  )
}

derived_expr_recruitment <- function(fit, year) {
  lik <- "b0[PopulationName[i]]"
  if (year) {
    lik <- extract_lik(fit)
  }
  paste0(
    "for(i in 1:length(Annual)) {
  logit(prediction[i]) <- ",
    lik,
    "\n}"
  )
}

derived_expr_recruitment_trend <- function() {
  "for(i in 1:length(Annual)) {
  logit(prediction[i]) <- b0[PopulationName[i]] + bYear[PopulationName[i]] * CaribouYear[i]\n}"
}

derived_expr_survival_trend <- function(fit) {
  if (length(levels(fit$data$Month)) > 1) {
    "for(i in 1:length(Annual)) {
  logit(prediction[i]) <- logit(ilogit(b0[PopulationName[i]] + bYear[PopulationName[i]] * CaribouYear[i])^12)\n}"
  } else {
    "for(i in 1:length(Annual)) {
  logit(prediction[i]) <- b0[PopulationName[i]] + bYear[PopulationName[i]] * CaribouYear[i]\n}"
  }
}
