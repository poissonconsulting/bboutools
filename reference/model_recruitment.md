# Build Nimble recruitment model.

This is for use by developers.

## Usage

``` r
model_recruitment(
  data,
  year_random = TRUE,
  year_trend = TRUE,
  adult_female_proportion = 0.65,
  sex_ratio = 0.5,
  demographic_stochasticity = TRUE,
  priors = NULL
)
```

## Arguments

- data:

  The data.frame.

- year_random:

  A flag indicating whether to include year random effect. If FALSE,
  year is fitted as a fixed effect.

- year_trend:

  A flag indicating whether to fit a year trend effect. Year trend
  cannot be fit if there is also a fixed year effect (as opposed to
  random effect).

- adult_female_proportion:

  A number between 0 and 1 of the expected proportion of adults that are
  female. If NULL, the proportion is estimated from the data (i.e.,
  `Cows ~ Binomial(adult_female_proportion, Cows + Bulls)`) and a prior
  of dbeta(65, 35) is used. This prior can be changed via the `priors`
  argument.

- sex_ratio:

  A number between 0 and 1 of the proportion of females at birth.
  Deprecated for `bb_fit_recruitment(sex_ratio)`. **\[deprecated\]**

- demographic_stochasticity:

  A flag indicating whether to include demographic_stochasticity in the
  recruitment model.

- priors:

  A named vector of the parameter prior distribution values. Any missing
  values are assigned their default values in `priors_survival()` and
  `priors_recruitment()`. If NULL, all parameters are assigned their
  default priors.
