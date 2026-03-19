# Plot Year Recruitment

Plot annual recruitment estimates with credible limits. Recruitment is
adjusted following DeCesare et al. (2012) methods.

## Usage

``` r
bb_plot_year_recruitment(x, ...)

# S3 method for class 'data.frame'
bb_plot_year_recruitment(x, ...)

# S3 method for class 'bboufit_recruitment'
bb_plot_year_recruitment(x, conf_level = 0.95, estimate = median, ...)
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

- `bb_plot_year_recruitment(data.frame)`: Plot annual recruitment
  estimate for a data frame.

- `bb_plot_year_recruitment(bboufit_recruitment)`: Plot annual
  recruitment estimates for a bboufit_recruitment object.

## References

DeCesare, Nicholas J., Mark Hebblewhite, Mark Bradley, Kirby G. Smith,
David Hervieux, and Lalenia Neufeld. 2012 “Estimating Ungulate
Recruitment and Growth Rates Using Age Ratios.” The Journal of Wildlife
Management 76 (1): 144–53 https://doi.org/10.1002/jwmg.244.
