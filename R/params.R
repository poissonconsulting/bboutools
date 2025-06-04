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

#' Parameter Descriptions for bboutools Functions
#'
#' @param ... Unused parameters.
#' @param data The data.frame.
#' @param x The object.
#' @param object The object.
#' @param by A string of the column indicating group to derive predictions at.
#' @param conf_level A number between 0 and 1 of the confidence level.
#' @param include_random_effects A flag indicating whether to include random effects in coefficient table. Standard deviation estimates will always be included.
#' @param estimate 	A function to calculate the estimate.
#' @param min_random_year A whole number of the minimum number of years required to fit year as a random effect (as opposed to a fixed effect).
#' @param year_trend A flag indicating whether to fit a year trend effect.
#' Year trend cannot be fit if there is also a fixed year effect (as opposed to random effect).
#' @param include_uncertain_morts A flag indicating whether to include uncertain mortalities in total mortalities.
#' @param adult_female_proportion A number between 0 and 1 of the expected proportion of adults that are female.
#' If NULL, the proportion is estimated from the data (i.e., `Cows ~ Binomial(adult_female_proportion, Cows + Bulls)`) and a prior of dbeta(65, 35) is used.
#' This prior can be changed via the `priors` argument.
#' @param sex_ratio A number between 0 and 1 of the proportion of females at birth.
#' @param year A flag indicating whether to predict by year.
#' @param month A flag indicating whether to predict by month.
#' @param nthin A whole number of the thinning rate.
#' @param niters A whole number of the number of iterations per chain after thinning and burn-in.
#' @param priors A named vector of the parameter prior distribution values.
#' Any missing values are assigned their default values in `priors_survival()` and `priors_recruitment()`.
#' If NULL, all parameters are assigned their default priors.
#' @param inits A named vector of the parameter initial values.
#' Any missing values are assigned a default value of 0.
#' If NULL, all parameters are assigned a default value of 0.
#' @param survival An object of class 'bboufit_survival' (output of [`bb_fit_survival()`]).
#' @param recruitment An object of class 'bboufit_recruitment' (output of [`bb_fit_recruitment()`])
#' @param quiet A flag indicating whether to suppress messages and progress bars.
#' @param term A string of the term name.
#' @param sig_fig A whole number of the significant figures to round estimates by.
#' @param original_scale A flag indicating whether to return the estimates in the original scale.
#' @param year_random A flag indicating whether to include year random effect. If FALSE, year is fitted as a fixed effect.
#' @param year_start A whole number between 1 and 12 indicating the start of the caribou (i.e., biological) year. By default, April is set as the start of the caribou year.
#' @param rhat A number greater than 1 of the maximum rhat value required for model convergence.
#' @param params A named list of the parameter names and values to simulate.
#'
#' @keywords internal
#' @name params
NULL
