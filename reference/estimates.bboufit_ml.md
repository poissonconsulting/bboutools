# Estimates for bboufit_ml Object

Gets a named list of the estimated values by term.

## Usage

``` r
# S3 method for class 'bboufit_ml'
estimates(x, term = NULL, original_scale = FALSE, ...)
```

## Arguments

- x:

  The object.

- term:

  A string of the term name.

- original_scale:

  A flag indicating whether to return the estimates in the original
  scale.

- ...:

  Unused parameters.

## Value

A named list of the estimates.

## See also

[`tidy.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_survival_ml(bboudata::bbousurv_a)
  estimates(fit)
}
```
