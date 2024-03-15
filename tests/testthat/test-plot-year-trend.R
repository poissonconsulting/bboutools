test_that("bb_plot_year_trend_recruitment.bboufit_recruitment works", {
  plot <- bb_plot_year_trend_recruitment(bboutools:::fit_recruitment_trend)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_recruitment")
})

test_that("bb_plot_year_trend_recruitment.data.frame works", {
  prediction <- bb_predict_recruitment_trend(bboutools:::fit_recruitment_trend)
  plot <- bb_plot_year_trend_recruitment(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_recruitment_df")
})

test_that("bb_plot_year_trend_survival.bboufit_survival works", {
  plot <- bb_plot_year_trend_survival(bboutools:::fit_survival_trend)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_survival")
})

test_that("bb_plot_year_trend_survival.data.frame works", {
  prediction <- bb_predict_survival_trend(bboutools:::fit_survival_trend)
  plot <- bb_plot_year_trend_survival(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_survival_df")
})

test_that("bb_plot_year_trend_recruitment.data.frame no rows", {
  prediction <- tibble::tribble(
    ~CaribouYear, ~estimate, ~lower, ~upper,
    1L, 0.5, 0.4, 0.6
  )

  prediction <- prediction[-1, ]

  plot <- bb_plot_year_trend_recruitment(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_trend_0")
})
