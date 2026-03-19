# Plot Month

Plots month estimates with credible limits.

## Usage

``` r
bb_plot_month(x, ...)

# S3 method for class 'data.frame'
bb_plot_month(x, ...)

# S3 method for class 'bboufit_survival'
bb_plot_month(x, conf_level = 0.95, estimate = median, ...)
```

## Arguments

- x:

  The object.

- ...:

  Unused parameters.

- conf_level:

  A number between 0 and 1 of the confidence level.

- estimate:

  A function to calculate the estimate.

## Methods (by class)

- `bb_plot_month(data.frame)`: Plot monthly estimate for a data frame.

- `bb_plot_month(bboufit_survival)`: Plot monthly estimates for a
  bboufit_survival object.
