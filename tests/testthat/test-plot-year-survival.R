test_that("plot_year_survival.survival works", {
  plot <- bb_plot_year_survival(bboutools:::fit_survival)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_survival_survival")
})

test_that("plot_year_survival.data.frame works", {
  prediction <- predict(bboutools:::fit_survival)
  plot <- bb_plot_year_survival(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_survival_predict_survival")
})
