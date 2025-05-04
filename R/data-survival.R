# Copyright 2022-2023 Environment and Climate Change Canada
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

data_clean_survival <- function(data, quiet) {
  data <- remove_missing(data, quiet = quiet)
  data <- remove_0(data, "StartTotal", quiet = quiet)

  data
}

data_prep_survival <- function(data, include_uncertain_morts = TRUE,
                               year_start = 4L) {
  data$Mortalities <- data$MortalitiesCertain
  if (include_uncertain_morts) {
    data$Mortalities <- data$Mortalities + data$MortalitiesUncertain
  }
  data$Year <- caribou_year(data$Year, data$Month, year_start = year_start)
  data$Annual <- factor(data$Year)

  # leaves month but sets factor levels to be caribou month for model
  nmonth <- length(unique(data$Month))
  data$Month <- factor(data$Month, levels = month_levels(year_start, n = nmonth))

  data
}

data_adjust_intercept <- function(data) {
  year_b0 <- year_intercept(data)
  levels <- unique(data$Year)
  levels <- levels[levels != year_b0]
  levels <- c(year_b0, levels)
  data$Annual <- factor(data$Year, levels = levels)
  data
}

data_list_survival <- function(data) {
  data <- rescale(data, scale = "Year")
  x <- list(
    nObs = nrow(data),
    StartTotal = data$StartTotal,
    Mortalities = data$Mortalities,
    nMonth = length(unique(data$Month)),
    Month = as.integer(data$Month),
    nAnnual = length(unique(data$Annual)),
    Year = data$Year,
    Annual = as.integer(data$Annual)
  )

  x
}
