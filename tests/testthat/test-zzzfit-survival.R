test_that("survival default works", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  fit <- bb_fit_survival(
    data = x, nthin = 1,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(coef(fit), "default")
})

test_that("survival year start works", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  fit <- bb_fit_survival(
    data = x, nthin = 1, year_start = 7L,
    quiet = TRUE
  )

  # last month in 1985 should be May (5)
  months85 <- fit$data$Month[fit$data$Year == 1985]
  expect_identical(max(factor_to_integer(months85)), 6L)
  expect_identical(max(as.integer(months85)), 12L)
  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(coef(fit), "year_start")
})

test_that("survival fixed works", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  fit <- bb_fit_survival(
    data = x, nthin = 1, niters = 100,
    min_random_year = Inf,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_setequal(pars(fit), c("b0", "bAnnual", "bMonth", "sMonth"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(coef(fit), "fixed")
})

test_that("survival year trend + random works", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  fit <- bb_fit_survival(
    data = x, nthin = 1, niters = 100,
    min_random_year = 5L, year_trend = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_setequal(pars(fit), c("b0", "bAnnual", "bMonth", "bYear", "sAnnual", "sMonth"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(coef(fit), "trend_random")
})

test_that("survival year trend only", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  fit <- bb_fit_survival(
    data = x, nthin = 1, niters = 100,
    min_random_year = Inf, year_trend = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_setequal(pars(fit), c("b0", "bMonth", "bYear", "sMonth"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(coef(fit), "trend_only")
})

test_that("can include_uncertain_morts", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  x$MortalitiesUncertain <- pmin(x$StartTotal - x$MortalitiesCertain, rbinom(nrow(x), prob = 0.1, size = 1))
  fit <- bb_fit_survival(
    data = x, nthin = 1, niters = 100,
    include_uncertain_morts = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(coef(fit), "include_uncertain_morts")
})

test_that("can set priors", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  priors <- c(b0_mu = 10, b0_sd = 0.5)

  fit <- bb_fit_survival(
    data = x, nthin = 1, niters = 100,
    priors = priors,
    quiet = TRUE
  )

  set.seed(101)
  fit2 <- bb_fit_survival(
    data = x, nthin = 1, niters = 100,
    priors = NULL,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_true(estimates(fit)$b0 > estimates(fit2)$b0)
  expect_snapshot_data(coef(fit), "prior")
})

test_that("fails with wrong prior", {
  x <- bboudata::bbousurv_a
  wrong_prior <- list(bInterce = 1)
  expect_chk_error(bb_fit_survival(x, nthin = 1L, priors = wrong_prior, quiet = TRUE), "Names in `priors` must match 'b0_mu', 'b0_sd', 'bAnnual_sd', 'bYear_mu', 'bYear_sd', 'sAnnual_rate' or 'sMonth_rate', not 'bInterce'.")
})

test_that("fails with multiple populations", {
  x <- rbind(bboudata::bbousurv_a, bboudata::bbousurv_b)
  expect_chk_error(bb_fit_survival(x, nthin = 1L, quiet = TRUE), "'PopulationName' can only contain one unique value.")
})

test_that("can set niters", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  fit <- bb_fit_survival(
    data = x,
    nthin = 1,
    niters = 10,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_identical(length(fit$samples$b0[1, , 1]), 10L)
  expect_snapshot_data(coef(fit), "niters")
})


test_that("works with less than 12 months", {
  skip_on_covr()

  x <- bboudata::bbousurv_c
  x <- x[!x$Month %in% 12, ]
  set.seed(101)
  fit <- bb_fit_survival(
    data = x,
    nthin = 1,
    niters = 100,
    year_start = 4L,
    quiet = TRUE
  )
  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_identical(length(estimates(fit)$bMonth), 11L)
  expect_snapshot_data(coef(fit), "less_than_12_months")
})
