# TODO - bboutools

Tracked from [GitHub Issues](https://github.com/poissonconsulting/bboutools/issues).

## Extensions Work (ECCC Contract)

Main PR: [#87 - bboutools extensions](https://github.com/poissonconsulting/bboutools/pull/87)

### SOW Deliverables

1. Allow for analysis of groups of populations with shared interannual variation — [#77](https://github.com/poissonconsulting/bboutools/issues/77)
2. Allow for analysis of aggregate annual survival data — [#78](https://github.com/poissonconsulting/bboutools/issues/78)
3. Allow for prediction of unobserved years — [#79](https://github.com/poissonconsulting/bboutools/issues/79)
4. Allow for analysis with priors informed by national analysis of demographic disturbance relationships — [#80](https://github.com/poissonconsulting/bboutools/issues/80)
5. Test extensions — [#81](https://github.com/poissonconsulting/bboutools/issues/81)
6. Describe extensions in vignettes and documentation — [#82](https://github.com/poissonconsulting/bboutools/issues/82)
7. Allow users of bboushiny to use the extensions — no GitHub issue yet

### Already completed on extensions branch (not in SOW but requested)

- [#75](https://github.com/poissonconsulting/bboutools/issues/75) - Updated data and models to use CaribouYear instead of Year
  - Josie (ECCC) reported that `bb_fit_survival()$data$Year` was returning CaribouYear values instead of calendar Year, which was confusing
  - Fixed by renaming the column to `CaribouYear` to make the distinction explicit
- [#85](https://github.com/poissonconsulting/bboutools/issues/85) - Allow fit functions to return model and data without MCMC sampling
  - Implemented via `niters = 0` in `bb_fit_survival/recruitment()`, which bypasses MCMC sampling but otherwise outputs the same returned object (including model, empty samples array etc.)
  - LandSciTech fork implemented this with a `do_fit = TRUE` arg; we used `niters = 0` instead
  - Not explicitly in contract but straightforward change; backwards compatible
- [#83](https://github.com/poissonconsulting/bboutools/issues/83) - Return samples from predict functions
  - Added exported `bb_predict_x_samples()` equivalents to all `bb_predict_x()` functions to return samples instead of coefficient tables
  - Added tests for each new samples function
  - LandSciTech fork had this in commit 79c0716; not explicitly in contract but straightforward

### Deliverable 1: Multi-population analysis — [#77](https://github.com/poissonconsulting/bboutools/issues/77)

- Extend survival, recruitment, and population growth models to analyze multiple populations simultaneously
- The extended models will assume that the distribution of interannual variation does not differ among populations, while allowing for variation in intercepts and trends among populations
- Populations do not need to have the same years. Missing year-population combos are treated as latent random effects drawn from the prior with no likelihood contribution
- Open question: in predictions or plots, should we only show observed combinations? Option to user, or standard behavior?
- Only needed for Bayesian implementation (not ML) - client only interested in Bayesian
- Josie provided a real Quebec multi-population dataset as a test case (also usable for deliverable 2): https://docs.google.com/spreadsheets/d/1FJZ06dc1-oKUEsNrrjSfqlEn3MGsXODQhJ3gmbqmp-s/edit?usp=sharing

### Deliverable 2: Aggregate annual survival data — [#78](https://github.com/poissonconsulting/bboutools/issues/78)

- Extend the survival model to allow for analysis of aggregate annual survival data when monthly survival data is not available
- Implemented in LandSciTech fork in [commit f6c3d7b](https://github.com/LandSciTech/bboutoolsMultiPop/commit/f6c3d7b07e2592f8d0ab3759a28a70047b4faab2)
- Josie points out that this needs more review/testing
- Quebec multi-population dataset (see deliverable 1) can be used as a test case for this

### Deliverable 3: Prediction of unobserved years — [#79](https://github.com/poissonconsulting/bboutools/issues/79)

- Extend survival, recruitment, and population growth models to allow for prediction of unobserved years
- Decision: implement at the model fitting stage (unobserved years as latent model nodes, annual random effects estimated directly in the model). This accommodates Josie's requirements below.
  - Note: an alternative (predict-stage) approach was considered — simulating from `rnorm(0, sAnnual)` — which works because the model has no temporal dependence in the annual random effect and avoids re-fitting. However, it cannot satisfy requirements 1-3 below.
- Requirements from Josie that the implementation must support:
  1. The option to "fit" models with no data to examine the prior predictions
  2. The option to fit random effects models given less than 5 years of observations
  3. The option to examine and use MCMC samples from an unobserved year
- LandSciTech fork implementation uses `allow_missing = TRUE` arg with NA rows in input data. Example:
  ```r
  surv <- bboudata::bbousurv_a
  surv <- surv[!(surv$Year %in% 1998:2002),]
  surv <- rbind(surv, data.frame(PopulationName = "A", Year = 1998, Month = 1,
                                 StartTotal = NA_integer_, MortalitiesCertain = NA_integer_,
                                 MortalitiesUncertain = NA_integer_))
  fit <- bb_fit_survival(surv, allow_missing = TRUE)
  ```

### Deliverable 4: National disturbance-informed priors — [#80](https://github.com/poissonconsulting/bboutools/issues/80)

- Extend survival and recruitment models to allow for analysis with Bayesian priors informed by national analysis of demographic disturbance relationships
- Default bboutools priors remain unchanged; disturbance-informed priors are an additional option
- Prior means vary with anthropogenic disturbance (both survival and recruitment) and fire disturbance (only recruitment), so there needs to be a way for users to specify their (static) level of anthropogenic and fire disturbance
- Josie created a lightweight package: [LandSciTech/bbouNationalPriors](https://github.com/LandSciTech/bbouNationalPriors)
  - A call with defaults uses the included table to get the priors without needing caribouMetrics
  - `force_run_model = TRUE` calculates the priors using caribouMetrics and nimble
- Current priors are informed by [Johnson et al. 2020](https://www.sciencedirect.com/science/article/pii/S0006320724003616). They are working toward adding new priors informed by a not-yet-published analysis that includes more demographic data. The table will eventually include more columns for different models, and the default will change from the current priors to priors from the new analysis/publication
- A few CWS regional partners are also interested in disturbance-informed priors; Josie wants it to be easy for bboutools users outside their group to see how informative priors alter their results

### Deliverable 5: Test extensions — [#81](https://github.com/poissonconsulting/bboutools/issues/81)

- Add unit tests covering all additional extension features

### Deliverable 6: Vignettes and documentation — [#82](https://github.com/poissonconsulting/bboutools/issues/82)

- Ensure all vignettes and docs are up to date with new features

### Deliverable 7: bboushiny extensions

- Allow users of [bboushiny](https://poissonconsulting.github.io/bboushiny/) to use the extensions
- NBCTC approved including disturbance-informed priors as an option in the Shiny app
- Troy wants to be able to see and edit the prior parameters in the app

## General Bugs / Features / Maintenance

### Bugs

- [#70](https://github.com/poissonconsulting/bboutools/issues/70) - Package loading order issues
  - Running bboutools functions without `library(bboutools)` causes unexpected behavior
  - Also breaks if nimble is loaded after bboutools
  - Namespace/dependency loading order issue
- [#72](https://github.com/poissonconsulting/bboutools/issues/72) - `bb_predict_growth` sex_ratio extraction
  - Should auto-extract `sex_ratio` from the recruitment fit object rather than requiring separate user input
- [#74](https://github.com/poissonconsulting/bboutools/issues/74) - Broken R-CMD-check on macOS
  - GitHub Actions CI failing on macOS

### Features

- [#66](https://github.com/poissonconsulting/bboutools/issues/66) - pkgdown function index
  - Add `_pkgdown.yml` config to organize exported functions into categories
- [#69](https://github.com/poissonconsulting/bboutools/issues/69) - Show priors in model code
  - Display prior distributions in printed model code output
- [#71](https://github.com/poissonconsulting/bboutools/issues/71) - Document data rescaling for priors
  - Clarify how Year is rescaled internally so users specify priors on the correct scale
- [#84](https://github.com/poissonconsulting/bboutools/issues/84) - Parallel MCMC chains
  - Probably not worth it - not possible for app deployed to shinyapps.io
- [#86](https://github.com/poissonconsulting/bboutools/issues/86) - Continue sampling on failed convergence
  - Instead of restarting MCMC from scratch with higher thinning, allow continuing from where it left off
  - Especially important for the Shiny app workflow
