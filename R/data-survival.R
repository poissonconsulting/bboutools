data_clean_survival <- function(data, quiet) {
  data <- remove_missing(data, quiet = quiet)
  data <- remove_0(data, "StartTotal", quiet = quiet)

  data
}

data_prep_survival <- function(data, include_uncertain_morts, year_start) {
  data$Year <- caribou_year(data$Year, data$Month, year_start = year_start)
  data$Annual <- factor(data$Year)
  # leaves month but sets factor levels to be caribou month for model
  nmonth <- length(unique(data$Month))
  data$Month <- factor(data$Month, levels = month_levels(year_start, n = nmonth))
  data$Mortalities <- data$MortalitiesCertain
  if (include_uncertain_morts) {
    data$Mortalities <- data$Mortalities + data$MortalitiesUncertain
  }
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
