# Get a Glance Summary of bboufit Object

Get a tibble of a one-row summary of the model fit.

## Usage

``` r
# S3 method for class 'bboufit'
glance(x, rhat = 1.05, ...)
```

## Arguments

- x:

  The object.

- rhat:

  A number greater than 1 of the maximum rhat value required for model
  convergence.

- ...:

  Unused parameters.

## Value

A tibble of the glance summary.

## See also

Other generics:
[`augment.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/augment.bboufit.md),
[`augment.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/augment.bboufit_ml.md),
[`glance.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/glance.bboufit_ml.md),
[`tidy.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit.md),
[`tidy.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit_ml.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_survival(bboudata::bbousurv_a)
  glance(fit)
}
```
