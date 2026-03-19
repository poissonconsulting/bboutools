# Disturbance-informed national survival priors

Returns intercept priors for the survival model informed by national
demographic-disturbance relationships (Johnson et al. 2020). The
returned priors override `b0_mu` and `b0_sd` in
[`bb_priors_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_priors_survival.md);
all other prior parameters retain their defaults.

## Usage

``` r
bb_priors_survival_national(anthro, fire_excl_anthro, annual = FALSE)
```

## Arguments

- anthro:

  A number between 0 and 100. Percent non-overlapping buffered
  anthropogenic disturbance.

- fire_excl_anthro:

  A number between 0 and 100. Percent fire disturbance not overlapping
  with anthropogenic disturbance. `anthro + fire_excl_anthro` must not
  exceed 100.

- annual:

  A flag (logical scalar) indicating whether to return annual (`TRUE`)
  or monthly (`FALSE`, default) survival priors. Use `annual = TRUE`
  when fitting models to aggregate annual survival data.

## Value

A named vector with elements `b0_mu` and `b0_sd`, suitable for passing
to the `priors` argument of
[`bb_fit_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_fit_survival.md).

## Details

Priors are looked up from a pre-computed table in the
[bbouNationalPriors](https://github.com/LandSciTech/bbouNationalPriors)
package. Integer values of `anthro` and `fire_excl_anthro` are matched
directly; non-integer values trigger a model run (slower).

## References

Johnson, C.A., Sutherland, G.D., Neave, E., Leblond, M., Kirby, P.,
Superbie, C. and McLoughlin, P.D., 2020. Science to inform policy:
linking population dynamics to habitat for a threatened species in
Canada. Journal of Applied Ecology, 57(7), pp.1314-1327.
[doi:10.1111/1365-2664.13637](https://doi.org/10.1111/1365-2664.13637)

## See also

[`bb_priors_survival()`](https://poissonconsulting.github.io/bboutools/reference/bb_priors_survival.md)
for default priors.

[`bb_priors_recruitment_national()`](https://poissonconsulting.github.io/bboutools/reference/bb_priors_recruitment_national.md)
for recruitment priors.

Other priors:
[`bb_priors_recruitment_national()`](https://poissonconsulting.github.io/bboutools/reference/bb_priors_recruitment_national.md)

## Examples

``` r
# Monthly survival priors (default)
nat_s <- bb_priors_survival_national(anthro = 50, fire_excl_anthro = 5)
nat_s
#>     b0_mu     b0_sd 
#> 4.3321205 0.5152558 

# Annual survival priors
nat_s_annual <- bb_priors_survival_national(anthro = 50, fire_excl_anthro = 5, annual = TRUE)
nat_s_annual
#>     b0_mu     b0_sd 
#> 1.7665175 0.5437549 

# Pass to bb_fit_survival via priors argument
# fit <- bb_fit_survival(data, priors = nat_s)
```
