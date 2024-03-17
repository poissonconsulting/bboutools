test_that("bb_predict_survival works", {
  predict <- bb_predict_survival(bboutools:::fit_survival)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_survival")
})

test_that("bb_predict_survival month works", {
  predict <- bb_predict_survival(bboutools:::fit_survival, year = FALSE, month = TRUE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_month")
})

test_that("bb_predict_survival month year works", {
  predict <- bb_predict_survival(bboutools:::fit_survival, year = TRUE, month = TRUE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_month_year")
})

test_that("bb_predict_survival one works", {
  predict <- bb_predict_survival(bboutools:::fit_survival, year = FALSE, month = FALSE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_1")
})

test_that("bb_predict_survival on fit with trend works", {
  predict <- bb_predict_survival(bboutools:::fit_survival_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend")
})

test_that("bb_predict_survival on fit with trend, month works", {
  predict <- bb_predict_survival(bboutools:::fit_survival_trend, year = FALSE, month = TRUE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend_month")
})

test_that("bb_predict_survival on fit with trend, month and year works", {
  predict <- bb_predict_survival(bboutools:::fit_survival_trend, year = TRUE, month = TRUE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend_month_year")
})

test_that("bb_predict_survival on fit with trend one works", {
  predict <- bb_predict_survival(bboutools:::fit_survival_trend, year = FALSE, month = FALSE)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend_1")
})

test_that("bb_predict_survival conf_level works", {
  predict <- bb_predict_survival(bboutools:::fit_survival,
    year = FALSE, month = FALSE,
    conf_level = 0.5
  )
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_conf_level")
})

test_that("bb_predict_survival estimate works", {
  predict <- bb_predict_survival(bboutools:::fit_survival,
    year = FALSE, month = FALSE,
    estimate = max
  )
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_survival_estimates")
})

test_that("generic predict survival works", {
  predict <- predict(bboutools:::fit_survival)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "predict_survival")
})

test_that("predict sig_fig works", {
  predict <- predict(bboutools:::fit_survival, sig_fig = 1)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "predict_survival_sig_fig")
})
