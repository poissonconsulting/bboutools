test_that("sample works for bboutfit", {
  x <- samples(fit_recruitment)
  expect_s3_class(x, "mcmcr")
  expect_equal(nchains(x), 3)
  expect_equal(niters(x), 1000)
})

test_that("sample works for bboutfit_ml", {
  x <- samples(fit_recruitment_ml)
  expect_s3_class(x, "mcmcr")
  expect_equal(nchains(x), 1)
  expect_equal(niters(x), 1)
})

