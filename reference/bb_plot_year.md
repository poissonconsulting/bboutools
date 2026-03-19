# Plot Year

Plots annual estimates with credible limits.

## Usage

``` r
bb_plot_year(x, ...)

# S3 method for class 'data.frame'
bb_plot_year(x, ...)

# S3 method for class 'bboufit'
bb_plot_year(x, conf_level = 0.95, estimate = median, ...)

# S3 method for class 'bboufit_ml'
bb_plot_year(x, conf_level = 0.95, estimate = median, ...)
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

- `bb_plot_year(data.frame)`: Plot annual estimate for a data frame.

- `bb_plot_year(bboufit)`: Plot annual estimates for a bboufit object.

- `bb_plot_year(bboufit_ml)`: Plot annual estimates for a bboufit_ml
  object.
