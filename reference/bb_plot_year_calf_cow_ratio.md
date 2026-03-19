# Plot Year Calf-Cow Ratio

Plot annual calf-cow ratio estimates with credible limits.

## Usage

``` r
bb_plot_year_calf_cow_ratio(x, ...)

# S3 method for class 'data.frame'
bb_plot_year_calf_cow_ratio(x, ...)

# S3 method for class 'bboufit_recruitment'
bb_plot_year_calf_cow_ratio(x, conf_level = 0.95, estimate = median, ...)
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

- `bb_plot_year_calf_cow_ratio(data.frame)`: Plot annual recruitment
  estimate for a data frame.

- `bb_plot_year_calf_cow_ratio(bboufit_recruitment)`: Plot annual
  calf-cow ratio estimates for a bboufit_recruitment object.
