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

library(tibble) # for nice printing of data frames
library(bboudata) # for example data
library(bboutools) # for estimating lambda etc

# select population
data_survival <- bboudata::bbousurv_a
data_recruitment <- bboudata::bbourecruit_a

print(data_survival)
print(data_recruitment)

# fit survival model - increase nthin to 50 for convergence
fit_survival <- bb_fit_survival(data_survival, nthin = 1)
glance(fit_survival)

# fit survival model - increase nthin to 50 for convergence
fit_recruitment <- bb_fit_recruitment(data_recruitment, nthin = 1)
glance(fit_recruitment)

# predict and plot monthly survival in a typical year
monthly_survival <- bb_predict_survival(fit_survival, month = TRUE, year = FALSE)
bb_plot_month_survival(monthly_survival)

# predict and plot annual survival in a typical month
annual_survival <- bb_predict_survival(fit_survival)
bb_plot_year_survival(annual_survival)

# predict and plot annual recruitment
annual_recruitment <- bb_predict_recruitment(fit_recruitment)
bb_plot_year_recruitment(annual_recruitment)

# predict and plot lambda
annual_growth <- bb_predict_growth(fit_survival, fit_recruitment)
bb_plot_year_growth(annual_growth)

# write results to csv
if (FALSE) {
  write.csv(data_survival, "data_survival.csv")
  write.csv(data_recruitment, "data_recruitment.csv")
  write.csv(annual_survival, "annual_survival.csv")
  write.csv(annual_recruitment, "annual_recruitment.csv")
  write.csv(annual_growth, "annual_growth.csv")
}
