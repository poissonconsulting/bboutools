# Changelog

## bboutools 1.3.0

### Breaking changes

- Models now use `CaribouYear` instead of `Year` throughout
  ([\#75](https://github.com/poissonconsulting/bboutools/issues/75)).
  This affects column names in output data frames from
  [`predict()`](https://rdrr.io/r/stats/predict.html),
  [`augment()`](https://generics.r-lib.org/reference/augment.html), and
  all `bb_predict_*()` functions.
- Multi-population models change parameter indexing from `bAnnual[1]` to
  `bAnnual[1,1]` and add a `PopulationName` column to output data frames
  ([\#77](https://github.com/poissonconsulting/bboutools/issues/77)).
  Single-population models are also affected.

### New features

- [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)
  and
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md)
  now support multiple populations in a single model fit
  ([\#77](https://github.com/poissonconsulting/bboutools/issues/77)).
  Population-level intercepts (`b0[k]`) and year random effects
  (`bAnnual[i,k]`) are estimated per population, while month effects and
  variance components are shared.
- [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)
  now accepts aggregate annual survival data (one row per population per
  year) when monthly collar data is unavailable
  ([\#78](https://github.com/poissonconsulting/bboutools/issues/78)).
  Annual data is auto-detected. The model skips the month random effect
  and does not apply monthly-to-annual exponentiation.
- [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)
  and
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md)
  now support prediction of unobserved years via `allow_missing = TRUE`
  ([\#79](https://github.com/poissonconsulting/bboutools/issues/79)).
  Users add placeholder rows with `PopulationName` and `Year` filled and
  all measurement columns `NA_integer_`. Predictions for unobserved
  years sample the year random effect from its prior, giving appropriate
  uncertainty.
- Added
  [`bb_priors_survival_national()`](https://poissonconsulting.github.io/bboutools/reference/bb_priors_survival_national.md)
  and
  [`bb_priors_recruitment_national()`](https://poissonconsulting.github.io/bboutools/reference/bb_priors_recruitment_national.md)
  to generate disturbance-informed intercept priors using the
  bbouNationalPriors package
  ([\#80](https://github.com/poissonconsulting/bboutools/issues/80)).
- Added `bb_predict_*_samples()` variants for all `bb_predict_*()`
  functions to return raw MCMC samples instead of summary tables
  ([\#83](https://github.com/poissonconsulting/bboutools/issues/83)).
- [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)
  and
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md)
  now accept `niters = 0` to build the model without MCMC sampling,
  useful for inspecting model structure
  ([\#85](https://github.com/poissonconsulting/bboutools/issues/85)).
- Added prior-only sampling for prior predictive checks
  ([\#91](https://github.com/poissonconsulting/bboutools/issues/91)).
  Users provide all-placeholder data with `allow_missing = TRUE` and
  `niters > 0` to sample from priors without observed data.
- Plot functions now automatically facet by `PopulationName` when
  multiple populations are present.

### Deprecated

- The `sex_ratio` argument in
  [`bb_predict_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment.md),
  [`bb_predict_growth()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_growth.md),
  [`bb_predict_population_change()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_population_change.md),
  and their `*_samples()` and `*_trend()` variants is deprecated
  ([\#72](https://github.com/poissonconsulting/bboutools/issues/72)).
  `sex_ratio` is now stored as an attribute at model fit time and
  extracted automatically by predict functions.

### Improvements

- Placeholder row detection now uses measurement columns instead of
  `Month`
  ([\#94](https://github.com/poissonconsulting/bboutools/issues/94)).
  This supports aggregate annual survival data where `Month` has a valid
  value.
- [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)
  and
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md)
  now emit an informational message listing detected unobserved
  CaribouYears by population when `quiet = FALSE`
  ([\#94](https://github.com/poissonconsulting/bboutools/issues/94)).

### Bug fixes

- Predictions for unobserved years now include the year random effect
  (`bAnnual`) drawn from the `Normal(0, sAnnual)` prior, resulting in
  wider credible intervals that better represent year-to-year process
  variance
  ([\#93](https://github.com/poissonconsulting/bboutools/issues/93)).
  Previously, the year random effect was zeroed out for unobserved
  years.

- Fixed ML model fitting error with nimble \>= 1.4.0 by using nimbleQuad
  for Laplace approximation
  ([\#88](https://github.com/poissonconsulting/bboutools/issues/88)).

- [`bb_predict_growth()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_growth.md)
  and
  [`bb_predict_population_change()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_population_change.md)
  now auto-filter to shared population and CaribouYear combinations
  instead of erroring when survival and recruitment fits differ.

- Fixed
  [`bb_predict_population_change()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_population_change.md)
  baseline row to use per-population minimum CaribouYear instead of
  global minimum.

- Fixed CaribouYear x-axis labels in `bb_plot_year_*()` and
  `bb_plot_year_trend_*()` to avoid duplicate integer labels.

- Added informative error when calling
  [`tidy()`](https://generics.r-lib.org/reference/tidy.html),
  [`coef()`](https://rdrr.io/r/stats/coef.html),
  [`glance()`](https://generics.r-lib.org/reference/glance.html),
  [`predict()`](https://rdrr.io/r/stats/predict.html), and other
  downstream functions on a Bayesian fit with `niters = 0`
  ([\#89](https://github.com/poissonconsulting/bboutools/issues/89)).

- Added informative error when nimble is not attached to the search
  path, e.g., when using `bboutools::` instead of
  [`library(bboutools)`](https://github.com/poissonconsulting/bboutools)
  ([\#70](https://github.com/poissonconsulting/bboutools/issues/70)).

### Internal

- [`model_code()`](https://poissonconsulting.github.io/bboutools/reference/model_code.md)
  now shows resolved numeric prior values instead of symbolic names
  (e.g., `dnorm(3, sd = 10)` instead of `dnorm(b0_mu, sd = b0_sd)`) and
  removes redundant [`{ }`](https://rdrr.io/r/base/Paren.html) blocks
  left by NIMBLE’s if/else resolution
  ([\#69](https://github.com/poissonconsulting/bboutools/issues/69)).
- Migrated user-facing messages from
  [`message()`](https://rdrr.io/r/base/message.html)/[`warning()`](https://rdrr.io/r/base/warning.html)/`abort_chk()`
  to cli package
  ([\#90](https://github.com/poissonconsulting/bboutools/issues/90)).
  `.inform_unobserved_years()` and `.warn_filtered_multi()` use plain
  [`message()`](https://rdrr.io/r/base/message.html) for clean display
  in bboushiny toast notifications.
- Reduced `sysdata.rda` size from ~7.7 MB to ~890 KB.

### Documentation

- Updated Get Started, Analytical Methods, and Priors vignettes for
  multi-population models, annual data, and national priors
  ([\#82](https://github.com/poissonconsulting/bboutools/issues/82)).
- Added Extensions article covering multi-population analysis, aggregate
  annual survival, unobserved year predictions, prior-only sampling, and
  raw MCMC samples
  ([\#82](https://github.com/poissonconsulting/bboutools/issues/82)).

## bboutools 1.2.0

- added
  [`bb_plot_year_calf_cow_ratio()`](https://poissonconsulting.github.io/bboutools/reference/bb_plot_year_calf_cow_ratio.md)
  and
  [`bb_plot_year_trend_calf_cow_ratio()`](https://poissonconsulting.github.io/bboutools/reference/bb_plot_year_trend_calf_cow_ratio.md).
- adjusted y-axis label in recruitment plots to ‘Adjusted Recruitment’
  to be more explicit.

## bboutools 1.1.0

- added
  [`bb_predict_calf_cow_ratio_trend()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio_trend.md)
  to mirror
  [`bb_predict_recruitment_trend()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment_trend.md)
  but for calf-cow ratio.

## bboutools 1.0.0

- cleaned up documentation following JOSS review.
- add Stable lifecycle badge.

## bboutools 0.1.0

- added `rhat` argument to
  [`glance()`](https://generics.r-lib.org/reference/glance.html) and
  [`converged()`](https://poissonconsulting.github.io/universals/reference/converged.html)
  to adjust convergence threshold, with default value of 1.05.
  Convergence no longer depends on `ess`.
- removed `exclude_year` argument in
  [`bb_fit_survival_ml()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival_ml.md)
  as failure to fit fixed year effect resolved with intercept
  adjustment.
- provide warning to user if start of caribou year (`year_start`) not
  matching for survival and recruitment model fits in
  [`bb_predict_growth()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_growth.md).

## bboutools 0.0.0.9007

- Added
  [`bb_predict_calf_cow_ratio()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio.md)
- [`bb_predict_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment.md)
  now predicts adjusted recruitment, following methods in DeCesare
  (2012). Previous output of
  [`bb_predict_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment.md)
  can now be obtained by running
  [`bb_predict_calf_cow_ratio()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio.md).
- Renamed `yearling_proportion_female` argument in
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md)
  to `sex_ratio`. This matches `bbouretro` language and arguments in
  [`bb_predict_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment.md).
- Changed default value of `include_uncertain_morts` argument in
  [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)
  to TRUE. This matches default behaviour in `bbouretro`.
- Added article on ‘Prior Selection and Influence’.
- Added example to “Analytical Methods” article.

## bboutools 0.0.0.9006

- Moved internal data checking functions to be exported function in
  `bboudata`.
- Updated bbtutorial vignette to mention the new data checking
  functions.

## bboutools 0.0.0.9005

- [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md)
  will error if there are any NA values in the PopulationName, Year,
  Month and Day columns.
- [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)
  will error if there are any NA values in the PopulationName, Year,
  Month, StartTotal, MortalitiesCertain and MortalitiesUncertain
  columns.

## bboutools 0.0.0.9004

Added ‘Getting Started’ vignette.

Added functions:

- [`bb_predict_survival_trend()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival_trend.md)
- [`bb_predict_recruitment_trend()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment_trend.md)
- [`bb_plot_year_trend_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_plot_year_trend_survival.md)
- [`bb_plot_year_trend_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_plot_year_trend_recruitment.md)
- [`bb_predict_population_change()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_population_change.md)
- [`bb_plot_year_population_change()`](https://poissonconsulting.github.io/bboutools/reference/bb_plot_year_population_change.md)
- [`plot()`](https://rdrr.io/r/graphics/plot.default.html) (plot
  traceplots for bboufit object)

Added arguments:

- `year_start = 4L` to
  [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)
  and
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md)
  to set caribou year start month as integer - (default April)
- `yearling_female_proportion = 0.5` to
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md)
  to set yearling sex ratio
- `year_trend = FALSE` to
  [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)
  and
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md)
  to fit model with year trend
- `include_random_effects = TRUE` to
  [`coef()`](https://rdrr.io/r/stats/coef.html)/[`tidy()`](https://generics.r-lib.org/reference/tidy.html)
  to provide possibility of removing individual random effect estimates

## bboutools 0.0.0.9003

- Switch MCMC engine from Jags to Nimble.
- Added recruitment/survival Maximum Likelihood fit functions:
  - [`bb_fit_survival_ml()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival_ml.md)
  - `bb_fit_recruitment_ml`
- Added summary methods for Maximum Likelihood output with class
  ‘bboufit_ml’.
- Changed how priors are passed to fit functions
  (e.g. `priors = c(b0_mu = 4, b0_sd = 2)` instead of
  `priors = list(b0 = "dnorm(4, 2^-2)")`).
- Added argument `sig_fig` to
  [`coef()`](https://rdrr.io/r/stats/coef.html)/[`tidy()`](https://generics.r-lib.org/reference/tidy.html)/[`predict()`](https://rdrr.io/r/stats/predict.html)
  methods to round estimates and lower/upper bounds to set significant
  figures.

## bboutools 0.0.0.9002

- [`bb_predict_growth()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_growth.md)
  now handles different years and doesn’t return month.
- Adjusted default priors.

## bboutools 0.0.0.9001

- Soft-deprecated
  [`bb_predict_lambda()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_growth.md)
  for
  [`bb_predict_growth()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_growth.md).
- Added
  [`bb_plot_year_growth()`](https://poissonconsulting.github.io/bboutools/reference/bb_plot_year_growth.md).
- Added
  [`bb_plot_year_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_plot_year_recruitment.md).
- Added
  [`bb_plot_month_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_plot_month_survival.md).
- Added
  [`bb_plot_year_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_plot_year_survival.md).
- Added
  [`bb_plot_month()`](https://poissonconsulting.github.io/bboutools/reference/bb_plot_month.md).

## bboutools 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
