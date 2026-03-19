# Survival model default priors

Prior distribution parameters and default values for survival model
parameters.

## Usage

``` r
bb_priors_survival()
```

## Value

A named vector.

## Details

Intercept

`b0 ~ Normal(mu = b0_mu, sd = b0_sd)`

Year Trend

`bYear ~ Normal(mu = bYear_mu, sd = bYear_sd)`

Year fixed effect

`bAnnual ~ Normal(mu = 0, sd = bAnnual_sd)`

Standard deviation of annual random effect

`sAnnual ~ Exponential(rate = sAnnual_rate)`

Standard deviation of month random effect

`sMonth ~ Exponential(rate = sMonth_rate)`

## Examples

``` r
bb_priors_survival()
#>        b0_mu        b0_sd     bYear_mu     bYear_sd   bAnnual_sd sAnnual_rate 
#>            3           10            0            2           10            1 
#>  sMonth_rate 
#>            1 
```
