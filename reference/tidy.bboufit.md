# Get Tidy Tibble from bboufit Object.

Get a tidy tibble of the coefficient estimates and confidence intervals
from Bayesian model fit.

## Usage

``` r
# S3 method for class 'bboufit'
tidy(
  x,
  conf_level = 0.95,
  estimate = median,
  sig_fig = 3,
  include_random_effects = TRUE,
  ...
)
```

## Arguments

- x:

  The object.

- conf_level:

  A number between 0 and 1 of the confidence level.

- estimate:

  A function to calculate the estimate.

- sig_fig:

  A whole number of the significant figures to round estimates by.

- include_random_effects:

  A flag indicating whether to include random effects in coefficient
  table. Standard deviation estimates will always be included.

- ...:

  Unused parameters.

## Value

A tibble of the tidy coefficient summary.

## See also

[`coef.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/coef.bboufit.md)

Other generics:
[`augment.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/augment.bboufit.md),
[`augment.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/augment.bboufit_ml.md),
[`glance.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/glance.bboufit.md),
[`glance.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/glance.bboufit_ml.md),
[`tidy.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit_ml.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_survival(bboudata::bbousurv_a)
  tidy(fit)
}
```
