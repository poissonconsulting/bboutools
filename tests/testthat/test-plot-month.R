test_that("plot_month.survival works", {
  plot <- bb_plot_month(bboutools:::fit_survival)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_month_survival")
})

test_that("plot_month.data.frame works", {
  prediction <- predict(bboutools:::fit_survival, month = TRUE, year = FALSE)
  plot <- bb_plot_month(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_month_predict_survival")
})

test_that("plot_month.data.frame one row", {
  prediction <- tibble::tribble(
    ~Month, ~estimate, ~lower, ~upper,
    1L, 0.5, 0.4, 0.6
  )

  plot <- bb_plot_month(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_month_predict_1")
})

test_that("plot_month.data.frame no rows", {
  prediction <- tibble::tribble(
    ~Month, ~estimate, ~lower, ~upper,
    1L, 0.5, 0.4, 0.6
  )

  prediction <- prediction[-1, ]

  plot <- bb_plot_month(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_month_predict_0")
})
