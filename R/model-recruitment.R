# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
# Copyright 2024 Province of Alberta
# Copyright (c) His Majesty the King in Right of Canada as represented by the
# Minister of the Environment 2025/(c) Sa Majeste le Roi du chef du Canada
# representee par le ministre de l'Environnement 2025.
# (Extension to multiple populations with shared interannual variation
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

model_data_recruitment <- function(
  data,
  year_start = year_start,
  allow_missing = FALSE,
  quiet
) {
  if (allow_missing) {
    measurement_cols <- c("Cows", "Bulls", "UnknownAdults", "Yearlings", "Calves")
    placeholder <- rowSums(is.na(data[measurement_cols])) == length(measurement_cols)
    population_names <- unique(data$PopulationName)
    if (any(placeholder)) {
      unobserved_years <- caribou_year(
        data$Year[placeholder],
        year_start,
        year_start = year_start
      )
      if (!quiet) {
        .inform_unobserved_years(data[placeholder, ], unobserved_years)
      }
    } else {
      unobserved_years <- integer(0)
    }
    data <- data[!placeholder, ]
  }
  if (allow_missing && nrow(data) == 0L) {
    all_years <- sort(unique(as.character(unobserved_years)))
    data <- data.frame(
      PopulationName = factor(character(), levels = as.character(population_names)),
      Annual = factor(character(), levels = all_years),
      CaribouYear = integer(),
      Cows = integer(),
      CowsBulls = integer(),
      UnknownAdults = integer(),
      Yearlings = integer(),
      Calves = integer()
    )
    nAnnualObserved <- 0L
  } else {
    data <- data_clean_recruitment(data, quiet = quiet)
    data <- data_prep_recruitment(data, year_start = year_start)
    nAnnualObserved <- length(levels(data$Annual))
    if (allow_missing) {
      all_years <- sort(union(
        levels(data$Annual),
        as.character(unobserved_years)
      ))
      data$Annual <- factor(data$Annual, levels = all_years)
    }
  }
  datal <- data_list_recruitment(data)
  list(datal = datal, data = data, nAnnualObserved = nAnnualObserved)
}

#' Build Nimble recruitment model.
#'
#' This is for use by developers.
#'
#' @inheritParams params
#' @param demographic_stochasticity A flag indicating whether to include demographic_stochasticity in the recruitment model.
#' @export
#' @keywords Internal
model_recruitment <-
  function(
    data,
    year_random = TRUE,
    year_trend = TRUE,
    adult_female_proportion = 0.65,
    sex_ratio = 0.5,
    demographic_stochasticity = TRUE,
    priors = NULL
  ) {
    constants <- list(
      b0_mu = priors[["b0_mu"]],
      b0_sd = priors[["b0_sd"]],
      bYear_mu = priors[["bYear_mu"]],
      bYear_sd = priors[["bYear_sd"]],
      sAnnual_rate = priors[["sAnnual_rate"]],
      bAnnual_sd = priors[["bAnnual_sd"]],
      adult_female_proportion_alpha = priors[["adult_female_proportion_alpha"]],
      adult_female_proportion_beta = priors[["adult_female_proportion_beta"]],
      sex_ratio = sex_ratio,
      year_random = year_random,
      year_trend = year_trend,
      fixed_proportion = !is.null(adult_female_proportion),
      adult_female_prop = adult_female_proportion,
      demographic_stochasticity = demographic_stochasticity
    )

    constants <- c(constants, data)

    code <- nimbleCode({
      for (k in 1:nPopulation) {
        b0[k] ~ dnorm(b0_mu, sd = b0_sd)
      }
      if (fixed_proportion) {
        adult_female_proportion <- adult_female_prop
      } else {
        adult_female_proportion ~ dbeta(
          adult_female_proportion_alpha,
          adult_female_proportion_beta
        )
      }

      if (year_random) {
        sAnnual ~ dexp(sAnnual_rate)
        for (i in 1:nAnnual) {
          for (k in 1:nPopulation) {
            bAnnual[i, k] ~ dnorm(0, sd = sAnnual)
          }
        }
      } else if (!year_random & !year_trend) {
        for (k in 1:nPopulation) {
          bAnnual[1, k] <- 0
          for (i in 2:nAnnual) {
            bAnnual[i, k] ~ dnorm(0, sd = bAnnual_sd)
          }
        }
      } else {
        # no annual offsets if using year trend only
        for (i in 1:nAnnual) {
          for (k in 1:nPopulation) {
            bAnnual[i, k] <- 0
          }
        }
      }

      if (year_trend) {
        for (k in 1:nPopulation) {
          bYear[k] ~ dnorm(bYear_mu, sd = bYear_sd)
        }
      } else {
        for (k in 1:nPopulation) {
          bYear[k] <- 0
        }
      }

      if (nObs > 0) {
        for (i in 1:nObs) {
          logit(eRecruitment[i]) <-
            b0[PopulationName[i]] +
            bAnnual[Annual[i], PopulationName[i]] +
            bYear[PopulationName[i]] * CaribouYear[i]
        }

        if (!fixed_proportion | demographic_stochasticity) {
          for (i in 1:nObs) {
            Cows[i] ~ dbin(adult_female_proportion, CowsBulls[i])
          }
        }

        if (demographic_stochasticity) {
          for (i in 1:nObs) {
            FemaleYearlings[i] ~ dbin(sex_ratio, Yearlings[i])
            OtherAdultsFemales[i] ~ dbin(
              adult_female_proportion,
              UnknownAdults[i]
            )
          }
        } else {
          for (i in 1:nObs) {
            FemaleYearlings[i] <- round(sex_ratio * Yearlings[i])
            OtherAdultsFemales[i] <-
              round(adult_female_proportion * UnknownAdults[i])
          }
        }

        for (i in 1:nObs) {
          AdultsFemales[i] <-
            # this replaces max(FemaleYearlings[i] + Cows[i] + OtherAdultsFemales[i], 1)
            # in original model because max cannot be used with ML
            ((FemaleYearlings[i] + Cows[i] + OtherAdultsFemales[i]) < 1) +
            FemaleYearlings[i] +
            Cows[i] +
            OtherAdultsFemales[i]
          Calves[i] ~ dbin(eRecruitment[i], AdultsFemales[i])
        }
      }
    })

    # always quiet
    verbose <- nimbleOptions("verbose")
    enable_derivs <- nimbleOptions("enableDerivs")
    nimbleOptions(verbose = FALSE)
    nimbleOptions(enableDerivs = TRUE)

    model <- nimbleModel(
      code,
      constants = constants,
      # priors too vague - causes warning of logprob = -Inf unless inits constrained
      inits = list(b0 = rnorm(data$nPopulation, -1, 2)),
      buildDerivs = TRUE,
      name = "bboumodel_recruitment"
    )

    # reset to user
    nimbleOptions(verbose = verbose)
    nimbleOptions(enableDerivs = enable_derivs)

    model
  }
