# Predict Survival Trend

Predict survival by year as trend line. Survival fit object provided
must be created with `year_trend = TRUE`.

## Usage

``` r
bb_predict_survival_trend(
  survival,
  conf_level = 0.95,
  estimate = median,
  sig_fig = 5
)
```

## Arguments

- survival:

  An object of class 'bboufit_survival' (output of
  [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)).

- conf_level:

  A number between 0 and 1 of the confidence level.

- estimate:

  A function to calculate the estimate.

- sig_fig:

  A whole number of the significant figures to round estimates by.

## Value

A tibble of the predicted estimates.

## See also

Other analysis:
[`bb_predict_calf_cow_ratio()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio.md),
[`bb_predict_calf_cow_ratio_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio_samples.md),
[`bb_predict_calf_cow_ratio_trend()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio_trend.md),
[`bb_predict_calf_cow_ratio_trend_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio_trend_samples.md),
[`bb_predict_growth()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_growth.md),
[`bb_predict_growth_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_growth_samples.md),
[`bb_predict_population_change()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_population_change.md),
[`bb_predict_population_change_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_population_change_samples.md),
[`bb_predict_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment.md),
[`bb_predict_recruitment_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment_samples.md),
[`bb_predict_recruitment_trend()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment_trend.md),
[`bb_predict_recruitment_trend_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment_trend_samples.md),
[`bb_predict_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival.md),
[`bb_predict_survival_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival_samples.md),
[`bb_predict_survival_trend_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival_trend_samples.md)
