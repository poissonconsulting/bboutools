# Fit Recruitment Model with Maximum Likelihood

Fit recruitment model with Maximum Likelihood using Nimble Laplace
Approximation.

## Usage

``` r
bb_fit_recruitment_ml(
  data,
  adult_female_proportion = 0.65,
  sex_ratio = 0.5,
  min_random_year = 5,
  year_trend = FALSE,
  year_start = 4L,
  inits = NULL,
  quiet = FALSE
)
```

## Arguments

- data:

  The data.frame.

- adult_female_proportion:

  A number between 0 and 1 of the expected proportion of adults that are
  female. If NULL, the proportion is estimated from the data (i.e.,
  `Cows ~ Binomial(adult_female_proportion, Cows + Bulls)`) and a prior
  of dbeta(65, 35) is used. This prior can be changed via the `priors`
  argument.

- sex_ratio:

  A number between 0 and 1 of the proportion of females at birth. This
  proportion is applied to yearlings.

- min_random_year:

  A whole number of the minimum number of years required to fit year as
  a random effect (as opposed to a fixed effect).

- year_trend:

  A flag indicating whether to fit a year trend effect. Year trend
  cannot be fit if there is also a fixed year effect (as opposed to
  random effect).

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

The start month of the Caribou year can be adjusted with `year_start`.

## See also

Other model:
[`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md),
[`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md),
[`bb_fit_survival_ml()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival_ml.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_recruitment_ml(bboudata::bbourecruit_a)
}
```
