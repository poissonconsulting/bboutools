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

priors_survival <- function() {
  c(
    b0_mu = 3,
    b0_sd = 10,
    bYear_mu = 0,
    bYear_sd = 2,
    bAnnual_sd = 10,
    sAnnual_rate = 1,
    sMonth_rate = 1
  )
}

priors_recruitment <- function() {
  c(
    b0_mu = -1,
    b0_sd = 5,
    bYear_mu = 0,
    bYear_sd = 2,
    bAnnual_sd = 5,
    sAnnual_rate = 1,
    adult_female_proportion_alpha = 65,
    adult_female_proportion_beta = 35
  )
}

#' Survival model default priors
#'
#' Prior distribution parameters and default values for survival model parameters.
#'
#' Intercept
#'
#' `b0 ~ Normal(mu = b0_mu, sd = b0_sd)`
#'
#' Year Trend
#'
#' `bYear ~ Normal(mu = bYear_mu, sd = bYear_sd)`
#'
#' Year fixed effect
#'
#' `bAnnual ~ Normal(mu = 0, sd = bAnnual_sd)`
#'
#' Standard deviation of annual random effect
#'
#' `sAnnual ~ Exponential(rate = sAnnual_rate)`
#'
#' Standard deviation of month random effect
#'
#' `sMonth ~ Exponential(rate = sMonth_rate)`
#'
#' @return A named vector.
#' @export
#'
#' @examples bb_priors_survival()
bb_priors_survival <- function() {
  priors_survival()
}

#' Recruitment model default priors
#'
#' Prior distribution parameters and default values for recruitment model parameters.
#'
#' Intercept
#'
#' `b0 ~ Normal(mu = b0_mu, sd = b0_sd)`
#'
#' Year Trend
#'
#' `bYear ~ Normal(mu = bYear_mu, sd = bYear_sd)`
#'
#' Year fixed effect
#'
#' `bAnnual ~ Normal(mu = 0, sd = bAnnual_sd)`
#'
#' Standard deviation of annual random effect
#'
#' `sAnnual ~ Exponential(rate = sAnnual_rate)`
#'
#' Adult female proportion
#'
#' `adult_female_proportion ~ Beta(alpha = adult_female_proportion_alpha, beta = adult_female_proportion_beta)`
#'
#' @return A named vector.
#' @export
#'
#' @examples bb_priors_survival()
bb_priors_recruitment <- function() {
  priors_recruitment()
}

#' Disturbance-informed national survival priors
#'
#' Returns intercept priors for the survival model informed by national
#' demographic-disturbance relationships (Johnson et al. 2020). The returned
#' priors override `b0_mu` and `b0_sd` in `bb_priors_survival()`; all other
#' prior parameters retain their defaults.
#'
#' Priors are looked up from a pre-computed table in the
#' [bbouNationalPriors](https://github.com/LandSciTech/bbouNationalPriors)
#' package. Integer values of `anthro` and `fire_excl_anthro` are matched
#' directly; non-integer values trigger a model run (slower).
#'
#' @param anthro A number between 0 and 100. Percent non-overlapping buffered
#'   anthropogenic disturbance.
#' @param fire_excl_anthro A number between 0 and 100. Percent fire disturbance
#'   not overlapping with anthropogenic disturbance. `anthro + fire_excl_anthro`
#'   must not exceed 100.
#' @param annual A flag (logical scalar) indicating whether to return annual
#'   (`TRUE`) or monthly (`FALSE`, default) survival priors. Use `annual = TRUE`
#'   when fitting models to aggregate annual survival data.
#' @return A named vector with elements `b0_mu` and `b0_sd`, suitable for
#'   passing to the `priors` argument of [bb_fit_survival()].
#' @seealso [bb_priors_survival()] for default priors.
#' @seealso [bb_priors_recruitment_national()] for recruitment priors.
#' @references
#' Johnson, C.A., Sutherland, G.D., Neave, E., Leblond, M., Kirby, P.,
#' Superbie, C. and McLoughlin, P.D., 2020. Science to inform policy: linking
#' population dynamics to habitat for a threatened species in Canada. Journal
#' of Applied Ecology, 57(7), pp.1314-1327.
#' \doi{10.1111/1365-2664.13637}
#' @family priors
#' @export
#' @examples
#' # Monthly survival priors (default)
#' nat_s <- bb_priors_survival_national(anthro = 50, fire_excl_anthro = 5)
#' nat_s
#'
#' # Annual survival priors
#' nat_s_annual <- bb_priors_survival_national(anthro = 50, fire_excl_anthro = 5, annual = TRUE)
#' nat_s_annual
#'
#' # Pass to bb_fit_survival via priors argument
#' # fit <- bb_fit_survival(data, priors = nat_s)
bb_priors_survival_national <- function(anthro, fire_excl_anthro, annual = FALSE) {
  .chk_disturbance(anthro, fire_excl_anthro)
  chk_flag(annual)
  result <- bbouNationalPriors::bbouNationalPriors(
    anthro = anthro,
    fire_excl_anthro = fire_excl_anthro,
    month = !annual
  )
  result$priors_survival
}

#' Disturbance-informed national recruitment priors
#'
#' Returns intercept priors for the recruitment model informed by national
#' demographic-disturbance relationships (Johnson et al. 2020). The returned
#' priors override `b0_mu` and `b0_sd` in `bb_priors_recruitment()`; all other
#' prior parameters retain their defaults.
#'
#' Priors are looked up from a pre-computed table in the
#' [bbouNationalPriors](https://github.com/LandSciTech/bbouNationalPriors)
#' package. Integer values of `anthro` and `fire_excl_anthro` are matched
#' directly; non-integer values trigger a model run (slower).
#'
#' @param anthro A number between 0 and 100. Percent non-overlapping buffered
#'   anthropogenic disturbance.
#' @param fire_excl_anthro A number between 0 and 100. Percent fire disturbance
#'   not overlapping with anthropogenic disturbance. `anthro + fire_excl_anthro`
#'   must not exceed 100.
#' @return A named vector with elements `b0_mu` and `b0_sd`, suitable for
#'   passing to the `priors` argument of [bb_fit_recruitment()].
#' @seealso [bb_priors_recruitment()] for default priors.
#' @seealso [bb_priors_survival_national()] for survival priors.
#' @references
#' Johnson, C.A., Sutherland, G.D., Neave, E., Leblond, M., Kirby, P.,
#' Superbie, C. and McLoughlin, P.D., 2020. Science to inform policy: linking
#' population dynamics to habitat for a threatened species in Canada. Journal
#' of Applied Ecology, 57(7), pp.1314-1327.
#' \doi{10.1111/1365-2664.13637}
#' @family priors
#' @export
#' @examples
#' nat_r <- bb_priors_recruitment_national(anthro = 50, fire_excl_anthro = 5)
#' nat_r
#'
#' # Pass to bb_fit_recruitment via priors argument
#' # fit <- bb_fit_recruitment(data, priors = nat_r)
bb_priors_recruitment_national <- function(anthro, fire_excl_anthro) {
  .chk_disturbance(anthro, fire_excl_anthro)
  result <- bbouNationalPriors::bbouNationalPriors(
    anthro = anthro,
    fire_excl_anthro = fire_excl_anthro
  )
  result$priors_recruitment
}
