test_that("bb_predict_calf_cow_ratio works", {
  predict <- bb_predict_calf_cow_ratio(bboutools:::fit_recruitment)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_calf_cow")
})

test_that("bb_predict_calf_cow on fit with trend works", {
  predict <- bb_predict_calf_cow_ratio(bboutools:::fit_recruitment_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment_trend")
})

test_that("bb_predict_calf_cow works on ML", {
  predict <- bb_predict_calf_cow_ratio(bboutools:::fit_recruitment_ml)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_calf_cow_ml")
})

test_that("bb_predict_calf_cow works on fixed ML", {
  predict <- bb_predict_recruitment(bboutools:::fit_recruitment_ml_fixed)
  expect_true(all(!is.na(predict$estimate)))
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_calf_cow_ml_fixed")
})

test_that("bb_predict_recruitment works on ML with trend", {
  predict <- bb_predict_calf_cow_ratio(bboutools:::fit_recruitment_ml_trend)
  expect_s3_class(predict, "tbl")
  skip_on_os("linux")
  expect_snapshot_data(predict, "bb_predict_calf_cow_ml_trend")
})
