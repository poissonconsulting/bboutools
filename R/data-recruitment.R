
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
data_clean_recruitment <- function(data, quiet = FALSE) {
  data <- remove_missing(data,
    quiet = quiet,
    cols = c(
      "Yearlings", "Cows", "UnknownAdults",
      "Year", "Month", "Day"
    )
  )
  data
}

data_prep_recruitment <- function(data, year_start = 4L) {
  data$CowsBulls <- data$Cows + data$Bulls
  data$Year <- caribou_year(data$Year, data$Month, year_start = year_start)
  data <-
    data %>%
    dplyr::group_by(Year) %>%
    dplyr::summarize(
      Cows = sum(.data$Cows),
      CowsBulls = sum(.data$CowsBulls),
      UnknownAdults = sum(.data$UnknownAdults),
      Yearlings = sum(.data$Yearlings),
      Calves = sum(.data$Calves),
      PopulationName = dplyr::first(.data$PopulationName)
    ) %>%
    dplyr::ungroup()
  data$Annual <- factor(data$Year)

  data
}

data_list_recruitment <- function(data, model) {
  data <- rescale(data, scale = "Year")
  x <- list(
    nObs = nrow(data),
    Cows = data$Cows,
    CowsBulls = data$CowsBulls,
    UnknownAdults = data$UnknownAdults,
    Yearlings = data$Yearlings,
    Calves = data$Calves,
    nAnnual = length(unique(data$Annual)),
    Year = data$Year,
    Annual = as.integer(data$Annual)
  )
  x
}
