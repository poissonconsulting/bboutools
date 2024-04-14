test_that("survival default works", {
  skip_on_covr()
  skip_on_os("windows")

  x <- bboudata::bbousurv_a
  fit <- bb_fit_survival_ml(
    data = x,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bAnnual", "bMonth", "sAnnual", "sMonth"))
  expect_snapshot_data(coef(fit), "default")
})

test_that("survival fixed works", {
  skip_on_ci()
  skip_on_covr()

  x <- bboudata::bbousurv_a

  fit <- bb_fit_survival_ml(
    data = x,
    min_random_year = Inf,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bAnnual", "bMonth", "sMonth"))
  expect_snapshot_data(coef(fit), "fixed")
})

test_that("can exclude year effect", {
  skip_on_covr()
  skip_on_os("windows")

  x <- bboudata::bbousurv_a
  fit <- bb_fit_survival_ml(
    data = x,
    min_random_year = Inf,
    exclude_year = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bMonth", "sMonth"))
  expect_snapshot_data(coef(fit), "exclude_year")
})

test_that("year trend works", {
  skip_on_covr()
  skip_on_os("windows")

  x <- bboudata::bbousurv_a
  fit <- bb_fit_survival_ml(
    data = x,
    min_random_year = 5L,
    year_trend = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bAnnual", "bMonth", "bYear", "sAnnual", "sMonth"))
  expect_snapshot_data(coef(fit), "year_trend")
})

test_that("year trend only works", {
  skip_on_covr()
  skip_on_os("windows")

  x <- bboudata::bbousurv_a
  fit <- bb_fit_survival_ml(
    data = x,
    min_random_year = Inf,
    year_trend = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bMonth", "bYear", "sMonth"))
  expect_snapshot_data(coef(fit), "year_trend_only")
})

test_that("can include_uncertain_morts", {
  # produces NaN se for some terms
  skip_on_ci()
  skip_on_covr()

  set.seed(101)
  x <- bboudata::bbousurv_a
  x$MortalitiesUncertain <- pmin(x$StartTotal - x$MortalitiesCertain, rbinom(nrow(x), prob = 0.1, size = 1))
  fit <- bb_fit_survival_ml(
    data = x,
    include_uncertain_morts = TRUE,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bAnnual", "bMonth", "sAnnual", "sMonth"))
  expect_snapshot_data(coef(fit), "include_uncertain_morts")
})

test_that("can set inits", {
  skip_on_covr()
  skip_on_os("windows")

  x <- bboudata::bbousurv_a

  inits <- list(
    b0 = 5,
    sAnnual = 0.2,
    sMonth = 0.2
  )

  fit <- bb_fit_survival_ml(
    data = x,
    inits = inits,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_setequal(pars(fit), c("b0", "bMonth", "bAnnual", "sAnnual", "sMonth"))
  expect_snapshot_data(coef(fit), "inits")
})

test_that("fails with multiple populations", {
  x <- rbind(bboudata::bbousurv_a, bboudata::bbousurv_b)
  expect_chk_error(bb_fit_survival_ml(x, quiet = TRUE), "'PopulationName' can only contain one unique value.")
})

test_that("works with less than 12 months", {
  skip_on_covr()
  skip_on_os("windows")

  x <- bboudata::bbousurv_c
  x <- x[!x$Month %in% 12, ]
  fit <- bb_fit_survival_ml(
    data = x,
    quiet = TRUE
  )
  expect_s3_class(fit, "bboufit_ml")
  expect_identical(names(fit), c("summary", "mle", "model", "data", "model_code"))
  expect_s4_class(fit$summary, "AGHQuad_summary")
  expect_s4_class(fit$mle, "OptimResultNimbleList")
  expect_identical(sum(grepl(fit$summary$randomEffects$names, pattern = "Month")), 11L)
  expect_snapshot_data(coef(fit), "less_than_12_months")
})
