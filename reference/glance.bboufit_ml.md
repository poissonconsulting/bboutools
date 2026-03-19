# Get a Glance Summary of bboufit_ml Object

Get a tibble of a one-row summary of the model fit.

## Usage

``` r
# S3 method for class 'bboufit_ml'
glance(x, ...)
```

## Arguments

- x:

  The object.

- ...:

  Unused parameters.

## Value

A tibble of the glance summary.

## See also

Other generics:
[`augment.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/augment.bboufit.md),
[`augment.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/augment.bboufit_ml.md),
[`glance.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/glance.bboufit.md),
[`tidy.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit.md),
[`tidy.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit_ml.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_survival_ml(bboudata::bbousurv_a)
  glance(fit)
}
```
