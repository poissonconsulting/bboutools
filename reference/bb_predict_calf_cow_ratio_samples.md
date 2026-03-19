# Predict Calf-Cow Ratio Samples

Predict calves per adult female by year. If year is FALSE, predictions
are made for a 'typical' year.

## Usage

``` r
bb_predict_calf_cow_ratio_samples(recruitment, year = TRUE)
```

## Arguments

- recruitment:

  An object of class 'bboufit_recruitment' (output of
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md))

- year:

  A flag indicating whether to predict by year.

## Value

A list with elements:

- `samples`: An `mcmcarray` with the MCMC samples.

- `data`: A `data.frame` containing the associated prediction data.

## See also

Other analysis:
[`bb_predict_calf_cow_ratio()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_calf_cow_ratio.md),
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
[`bb_predict_survival_trend()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival_trend.md),
[`bb_predict_survival_trend_samples()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival_trend_samples.md)
