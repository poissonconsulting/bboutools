# Build Nimble survival model.

This is for use by developers.

## Usage

``` r
model_survival(
  data,
  year_random = TRUE,
  year_trend = FALSE,
  priors = NULL,
  build_derivs = TRUE
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

- priors:

  A named vector of the parameter prior distribution values. Any missing
  values are assigned their default values in `priors_survival()` and
  `priors_recruitment()`. If NULL, all parameters are assigned their
  default priors.

- build_derivs:

  A flag indicating whether to build derivatives Laplace approximation.
