test_that("remove_0 works", {
  x <- bboudata::bbousurv_a

  expect_message(remove_0(x))
  x2 <- remove_0(x, quiet = TRUE)
  expect_s3_class(x2, "data.frame")
  expect_identical(names(x), names(x2))
  expect_identical(nrow(x) - nrow(x2), 1L)
})

test_that("remove_sum0 works", {
  x <- bboudata::bbourecruit_a

  expect_message(remove_sum0(x))
  x2 <- remove_sum0(x, quiet = TRUE)
  expect_s3_class(x2, "data.frame")
  expect_identical(names(x), names(x2))
  expect_identical(nrow(x) - nrow(x2), 1L)
})

test_that("remove_missing works", {
  x <- bboudata::bbousurv_a
  x[1, 4] <- NA_integer_

  expect_message(remove_missing(x))
  x2 <- remove_missing(x, quiet = TRUE)
  expect_s3_class(x2, "data.frame")
  expect_identical(names(x), names(x2))
  expect_identical(nrow(x) - nrow(x2), 1L)
})

test_that("prior checks work", {
  ## check priors
  priors <- priors_survival()
  # fails because bYear not provided
  expect_chk_error(.chk_priors(priors, c("bYear")))

  priors2 <- priors[1]
  # passes because some priors provided of the required
  expect_silent(.chk_priors(priors2, c("b0_mu", "b0_sd")))

  priors3 <- c(priors2, c(bInt = "nope"))
  expect_chk_error(.chk_priors(priors3, c("b0_mu", "b0_sd")))
})

test_that("year_trend checks work", {
  expect_silent(.chk_year_trend(fit_recruitment_trend))
  expect_chk_error(.chk_year_trend(fit_recruitment))
})
