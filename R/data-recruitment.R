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

data_prep_recruitment <- function(data, year_start) {
  data$CowsBulls <- data$Cows + data$Bulls
  data$Year <- caribou_year(data$Year, data$Month, year_start = year_start)
  data <- 
    data %>%
    dplyr::group_by(Year) %>%
    dplyr::summarize(Cows = sum(.data$Cows),
              CowsBulls = sum(.data$CowsBulls),
              UnknownAdults = sum(.data$UnknownAdults),
              Yearlings = sum(.data$Yearlings),
              Calves = sum(.data$Calves),
              PopulationName = dplyr::first(.data$PopulationName)) %>%
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
