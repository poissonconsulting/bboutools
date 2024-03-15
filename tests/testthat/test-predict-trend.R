test_that("bb_predict_survival_trend works", {
  predict <- bb_predict_survival_trend(bboutools:::fit_survival_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_survival_trend_trend")
})

test_that("bb_predict_survival_trend fails if no year trend fit", {
  expect_chk_error(bb_predict_survival_trend(bboutools:::fit_survival))
})

test_that("bb_predict_recruitment_trend works", {
  predict <- bb_predict_recruitment_trend(bboutools:::fit_recruitment_trend)
  expect_s3_class(predict, "tbl")
  expect_snapshot_data(predict, "bb_predict_recruitment_trend_trend")
})

test_that("bb_predict_recruitment_trend fails if no year trend fit", {
  expect_chk_error(bb_predict_recruitment_trend(bboutools:::fit_recruitment))
})
