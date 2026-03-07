test_that("substitute_prior_values replaces symbolic names", {
  code <- quote({
    b0 ~ dnorm(b0_mu, sd = b0_sd)
    sAnnual ~ dexp(sAnnual_rate)
  })
  constants <- c(b0_mu = 3, b0_sd = 10, sAnnual_rate = 1)
  result <- substitute_prior_values(code, constants)
  result_text <- deparse(result)
  expect_false(any(grepl("b0_mu", result_text)))
  expect_false(any(grepl("b0_sd", result_text)))
  expect_false(any(grepl("sAnnual_rate", result_text)))
  expect_true(any(grepl("\\b3\\b", result_text)))
  expect_true(any(grepl("\\b10\\b", result_text)))
})

test_that("substitute_prior_values ignores names not in code", {
  code <- quote({
    b0 ~ dnorm(b0_mu, sd = b0_sd)
  })
  constants <- c(b0_mu = 3, b0_sd = 10, not_in_code = 99)
  result <- substitute_prior_values(code, constants)
  result_text <- deparse(result)
  expect_false(any(grepl("99", result_text)))
})
