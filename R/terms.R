
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
params_survival <- function() {
  c(
    "b0",
    "sAnnual",
    "sMonth",
    "bMonth",
    "bAnnual",
    "bYear"
  )
}

inits_survival <- function() {
  c(
    b0 = 4,
    sAnnual = 1,
    sMonth = 1,
    bYear = 0
  )
}

params_recruitment <- function() {
  c(
    "b0",
    "adult_female_proportion",
    "sAnnual",
    "bAnnual",
    "bYear"
  )
}

inits_recruitment <- function() {
  c(
    b0 = -1.4,
    sAnnual = 1,
    adult_female_proportion = 0.65,
    bYear = 0
  )
}

replace_priors <- function(priors, new_prior) {
  if (is.null(new_prior)) {
    return(priors)
  }
  replace(priors, names(new_prior), new_prior)
}
