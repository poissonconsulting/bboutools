test_that("survival data checks work", {
  x <- bboudata::bbousurv_a

  x2 <- x
  x2$StartTotal[1] <- 10.5
  chk::expect_chk_error(.chk_data_survival(x2))
  x2 <- x
  x2$MortalitiesCertain[1] <- 10.5
  chk::expect_chk_error(.chk_data_survival(x2))
  x2$MortalitiesUncertain[1] <- 10.5
  chk::expect_chk_error(.chk_data_survival(x2))

  ### check that accepts additional columns
  x2 <- x
  x2$Week <- 50
  expect_silent(.chk_data_survival(x2))

  ### check that wont accept missing required column
  x2 <- x
  x2$StartTotal <- NULL
  expect_chk_error(.chk_data_survival(x2))
})

test_that("recruitment data checks work", {
  x <- bboudata::bbourecruit_a

  ### check wont accept non-integer
  x2 <- x
  x2$Year[1] <- 10.5
  chk::expect_chk_error(.chk_data_recruitment(x2))
  x2 <- x
  x2$Cows[1] <- 10.5
  chk::expect_chk_error(.chk_data_recruitment(x2))
  x2$Calves[1] <- 10.5
  chk::expect_chk_error(.chk_data_recruitment(x2))

  ### check that accepts additional columns
  x2 <- x
  x2$Week <- 50
  expect_silent(.chk_data_recruitment(x2))

  ### check that wont accept missing required column
  x2 <- x
  x2$Calves <- NULL
  expect_chk_error(.chk_data_recruitment(x2))
})

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

test_that("error if missing values in survival data", {
  x <- bboudata::bbousurv_a
  x[1, 1] <- NA_character_
  expect_error(
    .chk_data_survival(x),
    regexp = "PopulationName must not have any missing values\\."
  )
  
  x <- bboudata::bbousurv_a
  x[1, 2] <- NA_integer_
  expect_error(
    .chk_data_survival(x),
    regexp = "Year must not have any missing values\\."
  )
  
  x <- bboudata::bbousurv_a
  x[1, 3] <- NA_integer_
  expect_error(
    .chk_data_survival(x),
    regexp = "Month must not have any missing values\\."
  )
  
  x <- bboudata::bbousurv_a
  x[1, 4] <- NA_integer_
  expect_error(
    .chk_data_survival(x),
    regexp = "StartTotal must not have any missing values\\."
  )
  
  x <- bboudata::bbousurv_a
  x[1, 5] <- NA_integer_
  expect_error(
    .chk_data_survival(x),
    regexp = "MortalitiesCertain must not have any missing values\\."
  )
  
  x <- bboudata::bbousurv_a
  x[1, 6] <- NA_integer_
  expect_error(
    .chk_data_survival(x),
    regexp = "MortalitiesUncertain must not have any missing values\\."
  )
})

test_that("error if missing values in recruitment dates and popname column", {
  x <- bboudata::bbourecruit_a
  x[1, 1] <- NA_character_
  expect_error(
    .chk_data_recruitment(x),
    regexp = "PopulationName must not have any missing values\\."
  )
  
  x <- bboudata::bbourecruit_a
  x[1, 2] <- NA_integer_
  expect_error(
    .chk_data_recruitment(x),
    regexp = "Year must not have any missing values\\."
  )
  
  x <- bboudata::bbourecruit_a
  x[1, 3] <- NA_integer_
  expect_error(
    .chk_data_recruitment(x),
    regexp = "Month must not have any missing values\\."
  )
  
  x <- bboudata::bbourecruit_a
  x[1, 4] <- NA_integer_
  expect_error(
    .chk_data_recruitment(x),
    regexp = "Day must not have any missing values\\."
  )
  
  x <- bboudata::bbourecruit_a
  x[1, 5] <- NA_integer_
  x_chk <- .chk_data_recruitment(x)
  expect_equal(
    .chk_data_recruitment(x),
    x
  )
})
