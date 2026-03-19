# Plot Year Survival

Plots annual survival estimates with credible limits.

## Usage

``` r
bb_plot_year_survival(x, ...)

# S3 method for class 'data.frame'
bb_plot_year_survival(x, ...)

# S3 method for class 'bboufit_survival'
bb_plot_year_survival(x, conf_level = 0.95, estimate = median, ...)
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

- `bb_plot_year_survival(data.frame)`: Plot annual survival estimate for
  a data frame.

- `bb_plot_year_survival(bboufit_survival)`: Plot annual survival
  estimates for a bboufit_survival object.
