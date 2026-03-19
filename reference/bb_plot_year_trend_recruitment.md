# Plot Annual Recruitment Trend

Plots annual recruitment estimates as trend line with credible limits.

## Usage

``` r
bb_plot_year_trend_recruitment(x, ...)

# S3 method for class 'data.frame'
bb_plot_year_trend_recruitment(x, ...)

# S3 method for class 'bboufit_recruitment'
bb_plot_year_trend_recruitment(x, conf_level = 0.95, estimate = median, ...)
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

- `bb_plot_year_trend_recruitment(data.frame)`: Plot annual recruitment
  estimate as trend line for a data frame.

- `bb_plot_year_trend_recruitment(bboufit_recruitment)`: Plot annual
  estimates as trend line for a bboufit_recruitment object.
