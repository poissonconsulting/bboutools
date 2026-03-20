<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# bboutools 1.3.0

## Breaking changes

* Models now use `CaribouYear` instead of `Year` throughout (#75). This affects column names in output data frames from `predict()`, `augment()`, and all `bb_predict_*()` functions. Existing bboutools code (e.g., `bb_fit_survival()`, `bb_predict_survival()`) is unaffected, but custom code that references `Year` columns in output data frames will need updating.
* Multi-population models change parameter indexing from `bAnnual[1]` to `bAnnual[1,1]` and add a `PopulationName` column to output data frames (#77). Single-population models are also affected. As above, this does not break standard bboutools workflows but may affect custom code that extracts parameters or manipulates output data frames directly.

## New features

* `bb_fit_survival()` and `bb_fit_recruitment()` now support multiple populations in a single model fit (#77). Population-level intercepts (`b0[k]`) and year random effects (`bAnnual[i,k]`) are estimated per population, while month effects and variance components are shared. `bb_predict_growth()` and `bb_predict_population_change()` auto-filter to shared population and CaribouYear combinations when survival and recruitment fits differ.
* `bb_fit_survival()` now accepts aggregate annual survival data (one row per population per year) when monthly collar data is unavailable (#78). Annual data is auto-detected. The model skips the month random effect and does not apply monthly-to-annual exponentiation.
* `bb_fit_survival()` and `bb_fit_recruitment()` now support prediction of unobserved years via `allow_missing = TRUE` (#79). Users add placeholder rows with `PopulationName` and `Year` filled and all measurement columns `NA_integer_`. Predictions for unobserved years draw the year random effect from its `Normal(0, sAnnual)` prior, giving appropriate uncertainty. An informational message lists detected unobserved CaribouYears by population when `quiet = FALSE`.
* Added `bb_priors_survival_national()` and `bb_priors_recruitment_national()` to generate disturbance-informed intercept priors using the bbouNationalPriors package (#80).
* Added `bb_predict_*_samples()` variants for all `bb_predict_*()` functions to return raw MCMC samples instead of summary tables (#83).
* `bb_fit_survival()` and `bb_fit_recruitment()` now accept `niters = 0` to build the model without MCMC sampling, useful for inspecting model structure (#85).
* Added prior-only sampling for prior predictive checks (#91). Users provide all-placeholder data with `allow_missing = TRUE` and `niters > 0` to sample from priors without observed data.
* Plot functions now automatically facet by `PopulationName` when multiple populations are present.

## Deprecated

* The `sex_ratio` argument in `bb_predict_recruitment()`, `bb_predict_growth()`, `bb_predict_population_change()`, and their `*_samples()` and `*_trend()` variants is deprecated (#72). `sex_ratio` is now stored as an attribute at model fit time and extracted automatically by predict functions.

## Bug fixes

* Fixed ML model fitting error with nimble >= 1.4.0 by using nimbleQuad for Laplace approximation (#88).
* Added informative error when nimble is not attached to the search path, e.g., when using `bboutools::` instead of `library(bboutools)` (#70).

## Internal

* `model_code()` now shows resolved numeric prior values instead of symbolic names (e.g., `dnorm(3, sd = 10)` instead of `dnorm(b0_mu, sd = b0_sd)`) and removes redundant `{ }` blocks left by NIMBLE's if/else resolution (#69).
* Migrated user-facing messages from `message()`/`warning()`/`abort_chk()` to cli package (#90). `.inform_unobserved_years()` and `.warn_filtered_multi()` use plain `message()` for clean display in bboushiny toast notifications.
* Reduced `sysdata.rda` size from ~7.7 MB to ~890 KB.

## Documentation

* Updated Get Started, Analytical Methods, and Priors vignettes for multi-population models, annual data, and national priors (#82).
* Added Extensions article covering multi-population analysis, aggregate annual survival, unobserved year predictions, prior-only sampling, and raw MCMC samples (#82).

# bboutools 1.2.0

- added `bb_plot_year_calf_cow_ratio()` and `bb_plot_year_trend_calf_cow_ratio()`.
- adjusted y-axis label in recruitment plots to 'Adjusted Recruitment' to be more explicit.

# bboutools 1.1.0

- added `bb_predict_calf_cow_ratio_trend()` to mirror `bb_predict_recruitment_trend()` but for calf-cow ratio. 

# bboutools 1.0.0

- cleaned up documentation following JOSS review.
- add Stable lifecycle badge.

# bboutools 0.1.0

- added `rhat` argument to `glance()` and `converged()` to adjust convergence threshold, with default value of 1.05. Convergence no longer depends on `ess`.
- removed `exclude_year` argument in `bb_fit_survival_ml()` as failure to fit fixed year effect resolved with intercept adjustment. 
- provide warning to user if start of caribou year (`year_start`) not matching for survival and recruitment model fits in `bb_predict_growth()`.

# bboutools 0.0.0.9007

- Added `bb_predict_calf_cow_ratio()`
- `bb_predict_recruitment()` now predicts adjusted recruitment, following methods in DeCesare (2012). Previous output of `bb_predict_recruitment()` can now be obtained by running `bb_predict_calf_cow_ratio()`.
- Renamed `yearling_proportion_female` argument in `bb_fit_recruitment()` to `sex_ratio`. This matches `bbouretro` language and arguments in `bb_predict_recruitment()`.
- Changed default value of `include_uncertain_morts` argument in `bb_fit_survival()` to TRUE. This matches default behaviour in `bbouretro`.
- Added article on 'Prior Selection and Influence'.
- Added example to "Analytical Methods" article. 

# bboutools 0.0.0.9006

- Moved internal data checking functions to be exported function in `bboudata`.
- Updated bbtutorial vignette to mention the new data checking functions.

# bboutools 0.0.0.9005

- `bb_fit_recruitment()`  will error if there are any NA values in the PopulationName, Year, Month and Day columns. 
- `bb_fit_survival()` will error if there are any NA values in the PopulationName, Year, Month, StartTotal, MortalitiesCertain and MortalitiesUncertain columns. 

# bboutools 0.0.0.9004

Added 'Getting Started' vignette. 

Added functions:

- `bb_predict_survival_trend()`
- `bb_predict_recruitment_trend()`
- `bb_plot_year_trend_survival()`
- `bb_plot_year_trend_recruitment()`
- `bb_predict_population_change()`
- `bb_plot_year_population_change()`
- `plot()` (plot traceplots for bboufit object)

Added arguments:

- `year_start = 4L` to `bb_fit_survival()` and `bb_fit_recruitment()` to set caribou year start month as integer - (default April)
- `yearling_female_proportion = 0.5` to `bb_fit_recruitment()` to set yearling sex ratio
- `year_trend = FALSE` to `bb_fit_survival()` and `bb_fit_recruitment()` to fit model with year trend
- `include_random_effects = TRUE` to `coef()`/`tidy()` to provide possibility of removing individual random effect estimates

# bboutools 0.0.0.9003

- Switch MCMC engine from Jags to Nimble.
- Added recruitment/survival Maximum Likelihood fit functions:
  - `bb_fit_survival_ml()`
  - `bb_fit_recruitment_ml`
- Added summary methods for Maximum Likelihood output with class 'bboufit_ml'. 
- Changed how priors are passed to fit functions (e.g. `priors = c(b0_mu = 4, b0_sd = 2)` instead of `priors = list(b0 = "dnorm(4, 2^-2)")`). 
- Added argument `sig_fig` to `coef()`/`tidy()`/`predict()` methods to round estimates and lower/upper bounds to set significant figures. 

# bboutools 0.0.0.9002

- `bb_predict_growth()` now handles different years and doesn't return month.
- Adjusted default priors.


# bboutools 0.0.0.9001

- Soft-deprecated `bb_predict_lambda()` for `bb_predict_growth()`.
- Added `bb_plot_year_growth()`.
- Added `bb_plot_year_recruitment()`.
- Added `bb_plot_month_survival()`.
- Added `bb_plot_year_survival()`.
- Added `bb_plot_month()`.


# bboutools 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
