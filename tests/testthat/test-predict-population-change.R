test_that("bb_predict_population_change works", {
  predict <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_popchange")
})

test_that("bb_predict_population_change works with trend", {
  predict <- bb_predict_population_change(bboutools:::fit_survival_trend, bboutools:::fit_recruitment_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_popchange_trend")
})

test_that("bb_predict_population_change conf_level works", {
  predict <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment,
                               conf_level = 0.5
  )
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_popchange_conf_level")
})

test_that("bb_predict_population_change estimate works", {
  predict <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment,
                               estimate = max
  )
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_pophange_estimates")
})

test_that("predict sig_fig works", {
  predict <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment, sig_fig = 1)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_popchange_sig_fig")
})
