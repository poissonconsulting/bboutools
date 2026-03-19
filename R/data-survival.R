# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
# Copyright 2024 Province of Alberta
# Copyright (c) His Majesty the King in Right of Canada as represented by the
# Minister of the Environment 2025/(c) Sa Majeste le Roi du chef du Canada
# representee par le ministre de l'Environnement 2025.
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

data_clean_survival <- function(data, quiet) {
  data <- remove_missing(data, quiet = quiet)
  data <- remove_0(data, "StartTotal", quiet = quiet)

  data
}

data_prep_survival <- function(
  data,
  include_uncertain_morts = TRUE,
  year_start = 4L
) {
  data$Mortalities <- data$MortalitiesCertain
  if (include_uncertain_morts) {
    data$Mortalities <- data$Mortalities + data$MortalitiesUncertain
  }
  data$CaribouYear <- caribou_year(
    data$Year,
    data$Month,
    year_start = year_start
  )
  data$Annual <- factor(data$CaribouYear)
  data$PopulationName <- factor(data$PopulationName)

  # leaves month but sets factor levels to be caribou month for model
  nmonth <- length(unique(data$Month))
  if (nmonth > 1) {
    data$Month <- factor(
      data$Month,
      levels = month_levels(year_start, n = nmonth)
    )
  } else {
    data$Month <- factor(year_start)
  }

  data
}

data_adjust_intercept <- function(data) {
  year_b0 <- year_intercept(data)
  levels <- unique(data$CaribouYear)
  levels <- levels[levels != year_b0]
  levels <- c(year_b0, levels)
  data$Annual <- factor(data$CaribouYear, levels = levels)
  data
}

data_list_survival <- function(data) {
  if (nrow(data) > 0) {
    data <- rescale(data, scale = "CaribouYear")
  }
  x <- list(
    nObs = nrow(data),
    StartTotal = data$StartTotal,
    Mortalities = data$Mortalities,
    nMonth = length(levels(data$Month)),
    Month = as.integer(data$Month),
    nAnnual = length(levels(data$Annual)),
    CaribouYear = data$CaribouYear,
    Annual = as.integer(data$Annual),
    PopulationName = as.integer(data$PopulationName),
    nPopulation = length(levels(data$PopulationName))
  )

  x
}
