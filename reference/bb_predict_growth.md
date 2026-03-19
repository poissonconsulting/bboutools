# Predict Population Growth Lambda

Predicts population growth (lambda) from survival and recruitment fit
objects using the Hatter-Bergerud equation (Hatter and Bergerud, 1991).

## Usage

``` r
bb_predict_growth(
  survival,
  recruitment,
  sex_ratio = deprecated(),
  conf_level = 0.95,
  estimate = median,
  sig_fig = 3
)

bb_predict_lambda(
  survival,
  recruitment,
  conf_level = 0.95,
  estimate = median,
  sig_fig = 3
)
```

## Arguments

- survival:

  An object of class 'bboufit_survival' (output of
  [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)).

- recruitment:

  An object of class 'bboufit_recruitment' (output of
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md))

- sex_ratio:

  A number between 0 and 1 of the proportion of females at birth.
  Deprecated for `bb_fit_recruitment(sex_ratio)`. **\[deprecated\]**

- conf_level:

  A number between 0 and 1 of the confidence level.

- estimate:

  A function to calculate the estimate.

- sig_fig:

  A whole number of the significant figures to round estimates by.

## Value

A tibble of the lambda estimates with upper and lower credible
intervals.

## Functions

- `bb_predict_lambda()`: Deprecated for `bb_predict_growth()`
  **\[deprecated\]**

## References

Hatter, Ian, and Wendy Bergerud. 1991. "Moose Recruitment, Adult
Mortality and Rate of Change" 27: 65–73.

## See also

Other analysis:
[`bb_predict_calf_cow_ratio()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio.md),
[`bb_predict_calf_cow_ratio_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio_samples.md),
[`bb_predict_calf_cow_ratio_trend()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio_trend.md),
[`bb_predict_calf_cow_ratio_trend_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio_trend_samples.md),
[`bb_predict_growth_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_growth_samples.md),
[`bb_predict_population_change()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_population_change.md),
[`bb_predict_population_change_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_population_change_samples.md),
[`bb_predict_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment.md),
[`bb_predict_recruitment_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment_samples.md),
[`bb_predict_recruitment_trend()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment_trend.md),
[`bb_predict_recruitment_trend_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment_trend_samples.md),
[`bb_predict_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival.md),
[`bb_predict_survival_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival_samples.md),
[`bb_predict_survival_trend()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival_trend.md),
[`bb_predict_survival_trend_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival_trend_samples.md)

## Examples

``` r
if (interactive()) {
  survival <- bb_fit_survival(bboudata::bbousurv_a)
  recruitment <- bb_fit_recruitment(bboudata::bbourecruit_a)
  growth <- bb_predict_growth(survival, recruitment)
}
```
