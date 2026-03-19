# Predict Survival

A wrapper on
[`bb_predict_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival.md).

## Usage

``` r
# S3 method for class 'bboufit_survival'
predict(
  object,
  year = TRUE,
  month = FALSE,
  conf_level = 0.95,
  estimate = median,
  sig_fig = 3,
  ...
)
```

## Arguments

- object:

  The object.

- year:

  A flag indicating whether to predict by year.

- month:

  A flag indicating whether to predict by month.

- conf_level:

  A number between 0 and 1 of the confidence level.

- estimate:

  A function to calculate the estimate.

- sig_fig:

  A whole number of the significant figures to round estimates by.

- ...:

  Unused parameters.

## See also

[`bb_predict_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_survival.md)
