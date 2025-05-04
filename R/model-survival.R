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

model_data_survival <- function(data,
                                include_uncertain_morts,
                                year_start,
                                quiet) {
  data <- data_clean_survival(data, quiet = quiet)
  data <- data_prep_survival(data,
    include_uncertain_morts = include_uncertain_morts,
    year_start = year_start
  )
  datal <- data_list_survival(data)
  list(datal = datal, data = data)
}

#' Build Nimble survival model.
#'
#' This is for use by developers.
#'
#' @inheritParams params
#' @param build_derivs A flag indicating whether to build derivatives Laplace approximation.
#' @export
#' @keywords Internal
model_survival <- function(data,
                           year_random = TRUE,
                           year_trend = FALSE,
                           priors = NULL,
                           build_derivs = TRUE) {
  constants <- list(
    b0_mu = priors[["b0_mu"]],
    b0_sd = priors[["b0_sd"]],
    bYear_mu = priors[["bYear_mu"]],
    bYear_sd = priors[["bYear_sd"]],
    sAnnual_rate = priors[["sAnnual_rate"]],
    sMonth_rate = priors[["sMonth_rate"]],
    bAnnual_sd = priors[["bAnnual_sd"]],
    year_random = year_random,
    year_trend = year_trend
  )

  constants <- c(constants, data)

  code <- nimbleCode({
    b0 ~ dnorm(b0_mu, sd = b0_sd)

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

    sMonth ~ dexp(sMonth_rate)
    for (i in 1:nMonth) {
      bMonth[i] ~ dnorm(0, sd = sMonth)
    }

    if (year_trend) {
      if (year_random) {
        for (i in 1:nObs) {
          logit(eSurvival[i]) <- b0 + bAnnual[Annual[i]] + bYear * Year[i] + bMonth[Month[i]]
        }
      } else {
        for (i in 1:nObs) {
          logit(eSurvival[i]) <- b0 + bYear * Year[i] + bMonth[Month[i]]
        }
      }
    } else {
      for (i in 1:nObs) {
        logit(eSurvival[i]) <- b0 + bAnnual[Annual[i]] + bMonth[Month[i]]
      }
    }

    for (i in 1:nObs) {
      Mortalities[i] ~ dbin(1 - eSurvival[i], StartTotal[i])
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
    inits = list(b0 = rnorm(1, 3, 2)),
    buildDerivs = build_derivs,
    name = "bboumodel_survival"
  )

  # reset to user
  nimbleOptions(verbose = verbose)
  nimbleOptions(enableDerivs = enable_derivs)

  model
}
