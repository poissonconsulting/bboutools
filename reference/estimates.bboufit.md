# Estimates for bboufit Object

Gets a named list of the estimated values by term.

## Usage

``` r
# S3 method for class 'bboufit'
estimates(x, term = NULL, ...)
```

## Arguments

- x:

  The object.

- term:

  A string of the term name.

- ...:

  Unused parameters.

## Value

A named list of the estimates.

## See also

[`tidy.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_survival(bboudata::bbousurv_a)
  estimates(fit)
}
```
