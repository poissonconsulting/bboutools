# Predict Recruitment

A wrapper on
[`bb_predict_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment.md).

## Usage

``` r
# S3 method for class 'bboufit_recruitment'
predict(
  object,
  year = TRUE,
  sex_ratio = deprecated(),
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

- sex_ratio:

  A number between 0 and 1 of the proportion of females at birth.
  Deprecated for `bb_fit_recruitment(sex_ratio)`. **\[deprecated\]**

- conf_level:

  A number between 0 and 1 of the confidence level.

- estimate:

  A function to calculate the estimate.

- sig_fig:

  A whole number of the significant figures to round estimates by.

- ...:

  Unused parameters.

## See also

[`bb_predict_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_predict_recruitment.md)
