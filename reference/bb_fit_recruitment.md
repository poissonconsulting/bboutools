# Fit Recruitment Model

Fit heirarchical Bayesian recruitment model using Nimble.

## Usage

``` r
bb_fit_recruitment(
  data,
  adult_female_proportion = 0.65,
  sex_ratio = 0.5,
  min_random_year = 5,
  year_trend = FALSE,
  year_start = 4L,
  nthin = 10,
  niters = 1000,
  priors = NULL,
  allow_missing = FALSE,
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

- nthin:

  A whole number of the thinning rate.

- niters:

  A whole number of the number of iterations per chain after thinning
  and burn-in.

- priors:

  A named vector of the parameter prior distribution values. Any missing
  values are assigned their default values in `priors_survival()` and
  `priors_recruitment()`. If NULL, all parameters are assigned their
  default priors.

- allow_missing:

  A flag indicating whether to allow unobserved years (placeholder rows
  with NA measurement columns). When TRUE, the year random effects for
  unobserved years are sampled from the prior distribution rather than
  being informed by data, giving predictions that reflect the
  population-level mean with appropriate uncertainty. Requires year to
  be fit as a random effect (i.e., not supported with fixed year
  effects). Not supported with Maximum Likelihood models.

- quiet:

  A flag indicating whether to suppress messages and progress bars.

## Value

A list of the Nimble model object, data and mcmcr samples.

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
[`bb_fit_recruitment_ml()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment_ml.md),
[`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md),
[`bb_fit_survival_ml()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival_ml.md)

## Examples

``` r
if (interactive()) {
  fit <- bb_fit_recruitment(bboudata::bbourecruit_a)
}
```
