test_that("bb_predict_recruitment works", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment")
})

test_that("bb_predict_recruitment one works", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment, year = FALSE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment_1")
})

test_that("bb_predict_recruitment on fit with trend works", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment_trend")
})

test_that("bb_predict_recruitment on fit with trend one works", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment_trend, year = FALSE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment_trend_1")
})

test_that("bb_predict_recruitment conf_level works", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment,
    year = FALSE,
    conf_level = 0.5
  )
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment_conf_level")
})

test_that("bb_predict_recruitment estimate works", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment,
    year = FALSE,
    estimate = max
  )
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment_estimates")
})

test_that("generic predict recruitment works", {
  predict <- predict(bboutools:::fit_recruitment)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "predict_recruitment")
})

test_that("predict sig_fig works", {
  predict <- predict(bboutools:::fit_recruitment, sig_fig = 1)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "predict_recruitment_sig_fig")
})

test_that("bb_predict_recruitment works on ML", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment_ml)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_recruitment_ml")
})

test_that("bb_predict_recruitment works on ML", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment_ml_fixed)
  expect_true(all(!is.na(predict$estimate)))
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_recruitment_ml_fixed")
})

test_that("bb_predict_recruitment works on ML with trend", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment_ml_trend)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_recruitment_ml_trend")
})

test_that("generic predict recruitment works on ML", {
  predict <- predict(bboutools:::fit_recruitment_ml)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "predict_recruitment_ml")
})
