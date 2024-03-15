test_that("plot_month_survival.survival works", {
  plot <- bb_plot_month_survival(bboutools:::fit_survival)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_month_survival_survival")
})

test_that("plot_month_survival.data.frame works", {
  prediction <- predict(bboutools:::fit_survival, month = TRUE, year = FALSE)
  plot <- bb_plot_month_survival(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_month_survival_predict_survival")
})
