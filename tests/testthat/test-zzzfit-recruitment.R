test_that("recruitment default works", {
  x <- bboudata::bbourecruit_a
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x, nthin = 1,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_setequal(pars(fit), c("b0", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "default")
})

test_that("recruitment can set caribou year", {
  x <- bboudata::bbourecruit_a
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x, nthin = 1, year_start = 10L,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_setequal(pars(fit), c("b0", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "year_start")
})

test_that("recruitment fixed works", {
  x <- bboudata::bbourecruit_a
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x, nthin = 1, niters = 100,
    min_random_year = Inf,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_setequal(pars(fit), c("b0", "bAnnual"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(coef(fit), "fixed")
})

test_that("recruitment trend works", {
  x <- bboudata::bbourecruit_a
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x, nthin = 1, niters = 100,
    min_random_year = 5,
    year_trend = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_setequal(pars(fit), c("b0", "bAnnual", "bYear", "sAnnual"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(coef(fit), "trend")
})

test_that("can change fixed adult_female_proportion", {
  x <- bboudata::bbourecruit_a
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x, nthin = 1, niters = 100,
    adult_female_proportion = 0.2,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_setequal(pars(fit), c("b0", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "adult_female_proportion")
})

test_that("can estimate adult_female_proportion", {
  x <- bboudata::bbourecruit_a
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x, nthin = 1, niters = 100,
    adult_female_proportion = NULL,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_setequal(pars(fit), c("adult_female_proportion", "b0", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "estimate_adult_female_proportion")
})

test_that("can change fixed yearling_female_proportion", {
  x <- bboudata::bbourecruit_a
  x$Yearlings[5:10] <- 1
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x, nthin = 1, niters = 100,
    yearling_female_proportion = 0.2,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_setequal(pars(fit), c("b0", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "yearling_female_proportion")
})

test_that("can set priors", {
  x <- bboudata::bbourecruit_a
  set.seed(101)

  priors <- list(
    adult_female_proportion_alpha = 10,
    adult_female_proportion_beta = 90,
    b0_mu = 20,
    b0_sd = 0.5
  )

  fit <- bb_fit_recruitment(
    data = x, nthin = 1, niters = 100,
    adult_female_proportion = NULL,
    priors = priors,
    quiet = TRUE
  )

  set.seed(101)
  fit2 <- bb_fit_recruitment(
    data = x, nthin = 1, niters = 100,
    adult_female_proportion = NULL,
    priors = NULL,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_setequal(pars(fit), c("adult_female_proportion", "b0", "bAnnual", "sAnnual"))
  expect_true(estimates(fit)$adult_female_proportion < estimates(fit2)$adult_female_proportion)
  expect_true(estimates(fit)$b0 > estimates(fit2)$b0)
  expect_snapshot_data(coef(fit), "prior")
})

test_that("fails with wrong prior", {
  x <- bboudata::bbourecruit_a
  wrong_prior <- list(bInterce = 1)
  expect_chk_error(bb_fit_recruitment(x, nthin = 1L, priors = wrong_prior, quiet = TRUE), "Names in `priors` must match 'adult_female_proportion_alpha', 'adult_female_proportion_beta', 'b0_mu', 'b0_sd', 'bAnnual_sd', 'bYear_mu', 'bYear_sd' or 'sAnnual_rate', not 'bInterce'.")
})

test_that("fails with multiple populations", {
  x <- rbind(bboudata::bbourecruit_a, bboudata::bbourecruit_b)
  expect_chk_error(bb_fit_recruitment(x, nthin = 1L, quiet = TRUE), "'PopulationName' can only contain one unique value.")
})

test_that("can set niters", {
  x <- bboudata::bbourecruit_a
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x,
    nthin = 1,
    niters = 10,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_identical(length(fit$samples$b0[1, , 1]), 10L)
  expect_snapshot_data(coef(fit), "niters")
})
