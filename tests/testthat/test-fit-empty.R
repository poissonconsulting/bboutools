test_that("survival niters 0 works", {
  skip_on_covr()

  x <- bboudata::bbousurv_a
  set.seed(101)
  fit <- bb_fit_survival(
    data = x,
    niters = 0,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_survival")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(
    as.data.frame(unlist(summary(fit))),
    "empty_samples_survival"
  )
})

test_that("recruitment niters 0 works", {
  skip_on_covr()

  x <- bboudata::bbourecruit_a
  set.seed(101)
  fit <- bb_fit_recruitment(
    data = x,
    niters = 0,
    quiet = TRUE
  )

  expect_s3_class(fit, "bboufit")
  expect_s3_class(fit, "bboufit_recruitment")
  expect_identical(names(fit), c("model", "samples", "data", "model_code"))
  expect_s3_class(fit$samples, "mcmcr")
  expect_s3_class(fit$data, "data.frame")
  expect_snapshot_data(
    as.data.frame(unlist(summary(fit))),
    "empty_samples_recruitment"
  )
})
