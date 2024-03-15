test_that("bb_plot_year_growth works", {
  prediction <- bb_predict_growth(bboutools:::fit_survival, bboutools:::fit_recruitment)
  plot <- bb_plot_year_growth(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_growth")
})

test_that("bb_plot_year_population_change works", {
  prediction <- bb_predict_population_change(bboutools:::fit_survival, bboutools:::fit_recruitment)
  plot <- bb_plot_year_population_change(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_population_change")
})
