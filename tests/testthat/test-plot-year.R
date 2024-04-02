test_that("plot_year.recruitment works", {
  plot <- bb_plot_year(bboutools:::fit_recruitment)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_recruitment")
})

test_that("plot_year.recruitment ML works", {
  plot <- bb_plot_year(bboutools:::fit_recruitment_ml)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_recruitment_ml")
})

test_that("plot_year.survival works", {
  plot <- bb_plot_year(bboutools:::fit_survival)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_survival")
})

test_that("plot_year.survival ML works", {
  plot <- bb_plot_year(bboutools:::fit_survival_ml)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_survival_ml")
})

test_that("plot_year.data.frame works", {
  prediction <- predict(bboutools:::fit_survival)
  plot <- bb_plot_year(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_predict_survival")
})

test_that("plot_year.data.frame ML works", {
  prediction <- predict(bboutools:::fit_survival_ml)
  plot <- bb_plot_year(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_predict_survival_ml")
})

test_that("plot_year.data.frame one row", {
  prediction <- tibble::tribble(
    ~CaribouYear, ~estimate, ~lower, ~upper,
    1L, 0.5, 0.4, 0.6
  )

  plot <- bb_plot_year(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_predict_1")
})

test_that("plot_year.data.frame no rows", {
  prediction <- tibble::tribble(
    ~CaribouYear, ~estimate, ~lower, ~upper,
    1L, 0.5, 0.4, 0.6
  )

  prediction <- prediction[-1, ]

  plot <- bb_plot_year(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "plot_year_predict_0")
})
