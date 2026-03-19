# Get MCMC samples

Get MCMC samples from Nimble model.

## Usage

``` r
samples(x)

# S3 method for class 'bboufit'
samples(x)

# S3 method for class 'bboufit_ml'
samples(x)
```

## Arguments

- x:

  The object.

## Methods (by class)

- `samples(bboufit)`: Get MCMC samples from bboufit object.

- `samples(bboufit_ml)`: Create MCMC samples (1 iteration, 1 chain) from
  bboufit_ml object.
