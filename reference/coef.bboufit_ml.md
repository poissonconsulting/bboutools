# Get Tidy Tibble from bboufit_ml Object.

A wrapper on
[`tidy.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit_ml.md).

## Usage

``` r
# S3 method for class 'bboufit_ml'
coef(object, ...)
```

## Arguments

- object:

  The object.

- ...:

  Unused parameters.

## See also

[`tidy.bboufit_ml()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit_ml.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_recruitment_ml(bboudata::bbourecruit_a)
  coef(fit)
}
```
