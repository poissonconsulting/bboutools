# Parameter Descriptions for bboutools Functions

Parameter Descriptions for bboutools Functions

## Arguments

- ...:

  Unused parameters.

- data:

  The data.frame.

- x:

  The object.

- object:

  The object.

- by:

  A string of the column indicating group to derive predictions at.

- conf_level:

  A number between 0 and 1 of the confidence level.

- include_random_effects:

  A flag indicating whether to include random effects in coefficient
  table. Standard deviation estimates will always be included.

- estimate:

  A function to calculate the estimate.

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

- adult_female_proportion:

  A number between 0 and 1 of the expected proportion of adults that are
  female. If NULL, the proportion is estimated from the data (i.e.,
  `Cows ~ Binomial(adult_female_proportion, Cows + Bulls)`) and a prior
  of dbeta(65, 35) is used. This prior can be changed via the `priors`
  argument.

- sex_ratio:

  A number between 0 and 1 of the proportion of females at birth.
  Deprecated for `bb_fit_recruitment(sex_ratio)`. **\[deprecated\]**

- year:

  A flag indicating whether to predict by year.

- month:

  A flag indicating whether to predict by month.

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

- inits:

  A named vector of the parameter initial values. Any missing values are
  assigned a default value of 0. If NULL, all parameters are assigned a
  default value of 0.

- survival:

  An object of class 'bboufit_survival' (output of
  [`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md)).

- recruitment:

  An object of class 'bboufit_recruitment' (output of
  [`bb_fit_recruitment()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_recruitment.md))

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

- term:

  A string of the term name.

- sig_fig:

  A whole number of the significant figures to round estimates by.

- original_scale:

  A flag indicating whether to return the estimates in the original
  scale.

- year_random:

  A flag indicating whether to include year random effect. If FALSE,
  year is fitted as a fixed effect.

- year_start:

  A whole number between 1 and 12 indicating the start of the caribou
  (i.e., biological) year. By default, April is set as the start of the
  caribou year.

- rhat:

  A number greater than 1 of the maximum rhat value required for model
  convergence.

- params:

  A named list of the parameter names and values to simulate.
