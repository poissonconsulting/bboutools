model_data_recruitment <- function(data, year_start = year_start, quiet) {
  data <- data_clean_recruitment(data, quiet = quiet)
  data <- data_prep_recruitment(data, year_start = year_start)
  datal <- data_list_recruitment(data)
  list(datal = datal, data = data)
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
  function(data,
           year_random = TRUE,
           year_trend = TRUE,
           adult_female_proportion = 0.65,
           yearling_female_proportion = 0.5,
           demographic_stochasticity = TRUE,
           priors = NULL) {
    constants <- list(
      b0_mu = priors[["b0_mu"]],
      b0_sd = priors[["b0_sd"]],
      bYear_mu = priors[["bYear_mu"]],
      bYear_sd = priors[["bYear_sd"]],
      sAnnual_rate = priors[["sAnnual_rate"]],
      bAnnual_sd = priors[["bAnnual_sd"]],
      adult_female_proportion_alpha = priors[["adult_female_proportion_alpha"]],
      adult_female_proportion_beta = priors[["adult_female_proportion_beta"]],
      yearling_female_proportion = yearling_female_proportion,
      year_random = year_random,
      year_trend = year_trend,
      fixed_proportion = !is.null(adult_female_proportion),
      adult_female_prop = adult_female_proportion,
      demographic_stochasticity = demographic_stochasticity
    )

    constants <- c(constants, data)

    code <- nimbleCode({
      b0 ~ dnorm(b0_mu, sd = b0_sd)
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
          bAnnual[i] ~ dnorm(0, sd = sAnnual)
        }
      } else if (!year_random & !year_trend) {
        bAnnual[1] <- 0
        for (i in 2:nAnnual) {
          bAnnual[i] ~ dnorm(0, sd = bAnnual_sd)
        }
      }
      if (year_trend) {
        bYear ~ dnorm(bYear_mu, sd = bYear_sd)
      }

      if (year_trend) {
        if (year_random) {
          for (i in 1:nObs) {
            logit(eRecruitment[i]) <- b0 + bAnnual[Annual[i]] + bYear * Year[i]
          }
        } else {
          for (i in 1:nObs) {
            logit(eRecruitment[i]) <- b0 + bYear * Year[i]
          }
        }
      } else {
        for (i in 1:nObs) {
          logit(eRecruitment[i]) <- b0 + bAnnual[Annual[i]]
        }
      }

      if (!fixed_proportion | demographic_stochasticity) {
        for (i in 1:nObs) {
          Cows[i] ~ dbin(adult_female_proportion, CowsBulls[i])
        }
      }

      if (demographic_stochasticity) {
        for (i in 1:nObs) {
          FemaleYearlings[i] ~ dbin(yearling_female_proportion, Yearlings[i])
          OtherAdultsFemales[i] ~ dbin(adult_female_proportion, UnknownAdults[i])
        }
      } else {
        for (i in 1:nObs) {
          FemaleYearlings[i] <- round(yearling_female_proportion * Yearlings[i])
          OtherAdultsFemales[i] <-
            round(adult_female_proportion * UnknownAdults[i])
        }
      }

      for (i in 1:nObs) {
        AdultsFemales[i] <-
          # this replaces max(FemaleYearlings[i] + Cows[i] + OtherAdultsFemales[i], 1)
          # in original model because max cannot be used with ML
          ((FemaleYearlings[i] + Cows[i] + OtherAdultsFemales[i]) < 1) +
          FemaleYearlings[i] + Cows[i] + OtherAdultsFemales[i]
        Calves[i] ~ dbin(eRecruitment[i], AdultsFemales[i])
      }
    })

    # always quiet
    verbose <- nimbleOptions("verbose")
    enable_derivs <- nimbleOptions("enableDerivs")
    nimbleOptions(verbose = FALSE)
    nimbleOptions(enableDerivs = TRUE)

    model <- nimbleModel(code,
      constants = constants,
      # priors too vague - causes warning of logprob = -Inf unless inits constrained
      inits = list(b0 = rnorm(1, -1, 2)),
      buildDerivs = TRUE,
      name = "bboumodel_recruitment"
    )

    # reset to user
    nimbleOptions(verbose = verbose)
    nimbleOptions(enableDerivs = enable_derivs)

    model
  }
