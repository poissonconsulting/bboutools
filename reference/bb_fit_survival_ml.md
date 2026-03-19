# Fit Survival Model with Maximum Likelihood

Fits hierarchical survival model with Maximum Likelihood using Nimble
Laplace approximation.

## Usage

``` r
bb_fit_survival_ml(
  data,
  min_random_year = 5,
  year_trend = FALSE,
  include_uncertain_morts = FALSE,
  year_start = 4L,
  inits = NULL,
  quiet = FALSE
)
```

## Arguments

- data:

  The data.frame.

- min_random_year:

  A whole number of the minimum number of years required to fit year as
  a random effect (as opposed to a fixed effect).

- year_trend:

  A flag indicating whether to fit a year trend effect. Year trend
  cannot be fit if there is also a fixed year effect (as opposed to
  random effect).

- include_uncertain_morts:

  A flag indicating whether to include uncertain mortalities in total
  mortalities.

- year_start:

  A whole number between 1 and 12 indicating the start of the caribou
  (i.e., biological) year. By default, April is set as the start of the
  caribou year.

- inits:

  A named vector of the parameter initial values. Any missing values are
  assigned a default value of 0. If NULL, all parameters are assigned a
  default value of 0.

- quiet:

  A flag indicating whether to suppress messages and progress bars.

## Value

A list of the Nimble model object and Maximum Likelihood output with
estimates and standard errors on the transformed scale.

## Details

If the number of years is \> `min_random_year`, a fixed-effects model is
fit. Otherwise, a mixed-effects model is fit with random intercept for
each year. If `year_trend` is TRUE and the number of years is \>
`min_random_year`, the model will be fit with year as a continuous
effect (i.e. trend) and no fixed effect of year. If `year_trend` is TRUE
and the number of years is \<= `min_random_year`, the model will be fit
with year as a continuous effect and a random intercept for each year.

The model is always fit with random intercept for each month.

The start month of the Caribou year can be adjusted with `year_start`.

## See also

Other model:
[`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md),
[`bb_fit_recruitment_ml()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment_ml.md),
[`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_survival_ml(bboudata::bbousurv_a)
}
```
