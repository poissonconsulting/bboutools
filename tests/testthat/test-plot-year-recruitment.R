test_that("plot_year_recruitment.recruitment works", {
  plot <- bb_plot_year_recruitment(bboutools:::fit_recruitment)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "recruitment")
})

test_that("plot_year_recruitment.data.frame works", {
  prediction <- predict(bboutools:::fit_recruitment)
  plot <- bb_plot_year_recruitment(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "dataframe")
})

test_that("plot_year_recruitment.recruitment ML works", {
  plot <- bb_plot_year_recruitment(bboutools:::fit_recruitment_ml)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "recruitment_ml")
})

test_that("plot_year_recruitment.data.frame ML works", {
  prediction <- predict(bboutools:::fit_recruitment_ml)
  plot <- bb_plot_year_recruitment(prediction)
  expect_s3_class(plot, "ggplot")
  expect_snapshot_plot(plot, "dataframe_ml")
})

