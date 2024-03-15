.chk_data_survival <- function(data, x_name = deparse(substitute(data))) {
  nms <- c(
    "PopulationName", "Year", "Month", "StartTotal",
    "MortalitiesCertain", "MortalitiesUncertain"
  )
  chk_superset(names(data), nms, x_name = x_name)

  chk_character_or_factor(data$PopulationName, x_name = xname(x_name, "PopulationName"))
  chk_not_any_na(data$PopulationName, x_name = "PopulationName")
  .chk_population(data)

  chk_whole_numeric(data$Year, x_name = xname(x_name, "Year"))
  chk_gte(data$Year, 0, x_name = xname(x_name, "Year"))

  chk_whole_numeric(data$Month, x_name = xname(x_name, "Month"))
  chk_range(data$Month, range = c(1, 12), x_name = xname(x_name, "Month"))

  chk_whole_numeric(data$StartTotal, x_name = xname(x_name, "StartTotal"))
  chk_gte(data$StartTotal, 0, x_name = xname(x_name, "StartTotal"))

  chk_whole_numeric(data$MortalitiesCertain, x_name = xname(x_name, "MortalitiesCertain"))
  chk_gte(data$MortalitiesCertain, 0, x_name = xname(x_name, "MortalitiesCertain"))

  chk_whole_numeric(data$MortalitiesUncertain, x_name = xname(x_name, "MortalitiesUncertain"))
  chk_gte(data$MortalitiesUncertain, 0, x_name = xname(x_name, "MortalitiesUncertain"))

  check_key(data, c("PopulationName", "Year", "Month"))

  chk_not_any_na(data$Year, x_name = "Year")
  chk_not_any_na(data$Month, x_name = "Month")
  chk_not_any_na(data$StartTotal, x_name = "StartTotal")
  chk_not_any_na(data$MortalitiesCertain, x_name = "MortalitiesCertain")
  chk_not_any_na(data$MortalitiesUncertain, x_name = "MortalitiesUncertain")
  
  .chk_sum_less(data, c("MortalitiesCertain", "MortalitiesUncertain"), "StartTotal")

  invisible(data)
}

.chk_data_recruitment <- function(data, x_name = deparse(substitute(data))) {
  nms <- c(
    "PopulationName", "Year", "Month", "Day", "Cows",
    "Bulls", "UnknownAdults", "Yearlings", "Calves"
  )
  chk_superset(names(data), nms, x_name = x_name)

  chk_character_or_factor(data$PopulationName, x_name = xname(x_name, "PopulationName"))
  chk_not_any_na(data$PopulationName, x_name = "PopulationName")
  .chk_population(data)

  chk_whole_numeric(data$Year, x_name = xname(x_name, "Year"))
  chk_gte(data$Year, 0, x_name = xname(x_name, "Year"))

  chk_whole_numeric(data$Month, x_name = xname(x_name, "Month"))
  chk_range(data$Month, range = c(1, 12), x_name = xname(x_name, "Month"))

  chk_whole_numeric(data$Day, x_name = xname(x_name, "Day"))
  chk_range(data$Day, range = c(1, 31), x_name = xname(x_name, "Day"))

  chk_not_any_na(data$Year, x_name = "Year")
  chk_not_any_na(data$Month, x_name = "Month")
  chk_not_any_na(data$Day, x_name = "Day")
  
  .chk_date(data$Year, data$Month, data$Day)

  chk_whole_numeric(data$Cows, x_name = xname(x_name, "Cows"))
  chk_gte(data$Cows, 0, x_name = xname(x_name, "Cows"))

  chk_whole_numeric(data$Bulls, x_name = xname(x_name, "Bulls"))
  chk_gte(data$Bulls, 0, x_name = xname(x_name, "Bulls"))

  chk_whole_numeric(data$UnknownAdults, x_name = xname(x_name, "UnknownAdults"))
  chk_gte(data$UnknownAdults, 0, x_name = xname(x_name, "UnknownAdults"))

  chk_whole_numeric(data$Yearlings, x_name = xname(x_name, "Yearlings"))
  chk_gte(data$Yearlings, 0, x_name = xname(x_name, "Yearlings"))

  chk_whole_numeric(data$Calves, x_name = xname(x_name, "Calves"))
  chk_gte(data$Calves, 0, x_name = xname(x_name, "Calves"))
  
  invisible(data)
}
