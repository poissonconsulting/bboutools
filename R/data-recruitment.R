# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
# Copyright 2024 Province of Alberta
# Copyright © His Majesty the King in Right of Canada as represented by the
# Minister of the Environment 2025/© Sa Majesté le Roi du chef du Canada
# représentée par le ministre de l'Environnement 2025.
# (Multi-population data handling borrowed from ECCC implementation
# in LandSciTech/bboutoolsMultiPop.)
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

data_clean_recruitment <- function(data, quiet = FALSE) {
  data <- remove_missing(
    data,
    quiet = quiet,
    cols = c(
      "Yearlings",
      "Cows",
      "UnknownAdults",
      "Year",
      "Month",
      "Day"
    )
  )
  data
}

data_prep_recruitment <- function(data, year_start = 4L) {
  data$CowsBulls <- data$Cows + data$Bulls
  data$CaribouYear <- caribou_year(
    data$Year,
    data$Month,
    year_start = year_start
  )
  data <-
    data %>%
    dplyr::group_by(CaribouYear, PopulationName) %>%
    dplyr::summarize(
      Cows = sum(.data$Cows),
      CowsBulls = sum(.data$CowsBulls),
      UnknownAdults = sum(.data$UnknownAdults),
      Yearlings = sum(.data$Yearlings),
      Calves = sum(.data$Calves),
      .groups = "drop"
    )
  data$Annual <- factor(data$CaribouYear)
  data$PopulationName <- factor(data$PopulationName)

  data
}

data_list_recruitment <- function(data, model) {
  if (nrow(data) > 0) {
    data <- rescale(data, scale = "CaribouYear")
  }
  x <- list(
    nObs = nrow(data),
    Cows = data$Cows,
    CowsBulls = data$CowsBulls,
    UnknownAdults = data$UnknownAdults,
    Yearlings = data$Yearlings,
    Calves = data$Calves,
    nAnnual = length(levels(data$Annual)),
    CaribouYear = data$CaribouYear,
    Annual = as.integer(data$Annual),
    PopulationName = as.integer(data$PopulationName),
    nPopulation = length(levels(data$PopulationName))
  )
  x
}
