# Get Augmented Data from bboufit_ml Object

Get a tibble of the original data with augmentation.

## Usage

``` r
# S3 method for class 'bboufit_ml'
augment(x, ...)
```

## Arguments

- x:

  The object.

- ...:

  Unused parameters.

## Value

A tibble of the augmented data.

## See also

Other generics:
[`augment.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/augment.bboufit.md),
[`glance.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/glance.bboufit.md),
[`glance.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/glance.bboufit_ml.md),
[`tidy.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit.md),
[`tidy.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit_ml.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_survival_ml(bboudata::bbousurv_a)
  augment(fit)
}
```
