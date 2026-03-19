# Get Augmented Data from bboufit Object

Get a tibble of the original data with augmentation.

## Usage

``` r
# S3 method for class 'bboufit'
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
[`augment.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/augment.bboufit_ml.md),
[`glance.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/glance.bboufit.md),
[`glance.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/glance.bboufit_ml.md),
[`tidy.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit.md),
[`tidy.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit_ml.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_survival(bboudata::bbousurv_a)
  augment(fit)
}
```
