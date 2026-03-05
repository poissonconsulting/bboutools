test_that("bb_priors_survival_national returns valid named vector", {
  x <- bb_priors_survival_national(anthro = 50, fire_excl_anthro = 5)
  expect_type(x, "double")
  expect_named(x, c("b0_mu", "b0_sd"))
  expect_true(all(names(x) %in% names(bb_priors_survival())))
})

test_that("bb_priors_recruitment_national returns valid named vector", {
  x <- bb_priors_recruitment_national(anthro = 50, fire_excl_anthro = 5)
  expect_type(x, "double")
  expect_named(x, c("b0_mu", "b0_sd"))
  expect_true(all(names(x) %in% names(bb_priors_recruitment())))
})

test_that("higher anthro gives lower survival b0_mu", {
  low <- bb_priors_survival_national(anthro = 1, fire_excl_anthro = 1)
  high <- bb_priors_survival_national(anthro = 95, fire_excl_anthro = 1)
  expect_gt(low["b0_mu"], high["b0_mu"])
})

test_that("annual = TRUE returns lower survival b0_mu than monthly", {
  monthly <- bb_priors_survival_national(anthro = 1, fire_excl_anthro = 1)
  annual <- bb_priors_survival_national(anthro = 1, fire_excl_anthro = 1, annual = TRUE)
  expect_gt(monthly["b0_mu"], annual["b0_mu"])
})

test_that("validates disturbance inputs", {
  expect_chk_error(bb_priors_survival_national(anthro = -1, fire_excl_anthro = 5))
  expect_chk_error(bb_priors_survival_national(anthro = 101, fire_excl_anthro = 5))
  expect_chk_error(bb_priors_survival_national(anthro = "a", fire_excl_anthro = 5))
  expect_chk_error(bb_priors_survival_national(anthro = 60, fire_excl_anthro = 50))
  expect_chk_error(bb_priors_recruitment_national(anthro = 50, fire_excl_anthro = -1))
  expect_chk_error(bb_priors_survival_national(anthro = 50, fire_excl_anthro = 5, annual = NA))
})
