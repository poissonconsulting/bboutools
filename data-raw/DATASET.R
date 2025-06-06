# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
# Copyright 2024 Province of Alberta
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# survival -------------------------------------------------------------
# random effect, no trend
x <- bboudata::bbousurv_a
set.seed(101)
fit_survival <- bb_fit_survival(
  data = x,
  nthin = 10,
  quiet = TRUE
)

set.seed(101)
fit_survival_fixed <- bb_fit_survival(
  data = x,
  nthin = 10,
  min_random_year = Inf,
  quiet = TRUE
)

# trend only
set.seed(101)
fit_survival_trend <- bb_fit_survival(
  data = x,
  nthin = 10,
  quiet = TRUE,
  min_random_year = Inf,
  year_trend = TRUE
)

fit_survival_ml <- bb_fit_survival_ml(data = x, quiet = TRUE, )

fit_survival_ml_fixed <- bb_fit_survival_ml(
  data = x,
  quiet = TRUE,
  min_random_year = Inf
)

fit_survival_ml_trend <- bb_fit_survival_ml(
  data = x,
  quiet = TRUE,
  year_trend = TRUE,
  min_random_year = Inf
)

# recruitment -------------------------------------------------------------
# random effect, no trend
x <- bboudata::bbourecruit_a
set.seed(101)
fit_recruitment <- bb_fit_recruitment(
  data = x,
  nthin = 10,
  quiet = TRUE
)

# trend with random (for get started vignette)
set.seed(101)
fit_recruitment_trend <- bb_fit_recruitment(
  data = x,
  nthin = 10,
  quiet = TRUE,
  year_trend = TRUE
)

fit_recruitment_ml <- bb_fit_recruitment_ml(data = x, quiet = TRUE, )

fit_recruitment_ml_fixed <- bb_fit_recruitment_ml(
  data = x,
  quiet = TRUE,
  min_random_year = Inf
)

fit_recruitment_ml_trend <- bb_fit_recruitment_ml(
  data = x,
  quiet = TRUE,
  year_trend = TRUE,
  min_random_year = Inf
)

# model object is too large to store and not required for testing downstream functions
fit_recruitment$model <- NULL
fit_recruitment_trend$model <- NULL
fit_survival$model <- NULL
fit_survival_fixed$model <- NULL
fit_survival_trend$model <- NULL
fit_recruitment_ml$model <- NULL
fit_recruitment_ml_fixed$model <- NULL
fit_survival_ml$model <- NULL
fit_survival_ml_fixed$model <- NULL
fit_recruitment_ml_trend$model <- NULL
fit_survival_ml_trend$model <- NULL

usethis::use_data(
  fit_recruitment,
  fit_recruitment_trend,
  fit_survival,
  fit_survival_fixed,
  fit_survival_trend,
  fit_survival_ml,
  fit_survival_ml_fixed,
  fit_recruitment_ml,
  fit_recruitment_ml_fixed,
  fit_survival_ml_trend,
  fit_recruitment_ml_trend,
  internal = TRUE,
  overwrite = TRUE
)
