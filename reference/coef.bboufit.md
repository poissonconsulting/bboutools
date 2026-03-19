# Get Tidy Tibble from bboufit Object.

A wrapper on
[`tidy.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit.md).

## Usage

``` r
# S3 method for class 'bboufit'
coef(object, ...)
```

## Arguments

- object:

  The object.

- ...:

  Unused parameters.

## See also

[`tidy.bboufit()`](https://poissonconsulting.github.io/bboutools/reference/tidy.bboufit.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_recruitment(bboudata::bbourecruit_a)
  coef(fit)
}
```
