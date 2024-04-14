test_that("recruitment default works", {
  skip_on_ci()
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  fit <- bb_fit_recruitment_ml(
    data = x,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "default")
})

test_that("recruitment fixed year works", {
  skip_on_ci()
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  fit <- bb_fit_recruitment_ml(
    data = x,
    min_random_year = Inf,
    quiet = TRUE,
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bAnnual"))
  expect_snapshot_data(coef(fit), "fixed_year")
})

test_that("can change fixed adult_female_proportion", {
  skip_on_ci()
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  fit <- bb_fit_recruitment_ml(
    data = x,
    adult_female_proportion = 0.2,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "fixed_adult_female_proportion")
})

test_that("can change fixed yearling_female_proportion", {
  skip_on_ci()
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  x$Yearlings[5:10] <- 1
  fit <- bb_fit_recruitment_ml(
    data = x,
    yearling_female_proportion = 0.2,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "fixed_yearling_female_proportion")
})

test_that("can estimate adult_female_proportion", {
  # minor number rounding differences in fixed year estimates
  skip_on_ci()
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  fit <- bb_fit_recruitment_ml(
    data = x,
    adult_female_proportion = NULL,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "adult_female_proportion", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "estimate_adult_female_proportion")
})

test_that("can set inits", {
  skip_on_ci()
  skip_on_covr()

  x <- bboudata::bbourecruit_a

  inits <- list(
    b0 = -1.5,
    sAnnual = 0.1
  )

  fit <- bb_fit_recruitment_ml(
    data = x,
    adult_female_proportion = 0.5,
    inits = inits,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bAnnual", "sAnnual"))
  expect_snapshot_data(coef(fit), "inits")
})

test_that("fails with multiple populations", {
  x <- rbind(bboudata::bbourecruit_a, bboudata::bbourecruit_b)
  expect_chk_error(bb_fit_recruitment_ml(x, quiet = TRUE), "'PopulationName' can only contain one unique value.")
})
