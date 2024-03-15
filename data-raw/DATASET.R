# survival -------------------------------------------------------------
# random effect, no trend
x <- bboudata::bbousurv_a
set.seed(101)
fit_survival <- bb_fit_survival(
  data = x, nthin = 10,
  quiet = TRUE
)

# trend only
set.seed(101)
fit_survival_trend <- bb_fit_survival(
  data = x, nthin = 10,
  quiet = TRUE,
  min_random_year = Inf,
  year_trend = TRUE
)

fit_survival_ml <- bb_fit_survival_ml(
  data = x,
  quiet = TRUE,
)

# recruitment -------------------------------------------------------------
# random effect, no trend
x <- bboudata::bbourecruit_a
set.seed(101)
fit_recruitment <- bb_fit_recruitment(
  data = x, nthin = 10,
  quiet = TRUE
)

# trend only
set.seed(101)
fit_recruitment_trend <- bb_fit_recruitment(
  data = x, nthin = 10,
  quiet = TRUE, min_random_year = Inf, year_trend = TRUE
)

fit_recruitment_ml <- bb_fit_recruitment_ml(
  data = x,
  quiet = TRUE,
)

# model object is too large to store and not required for testing downstream functions
fit_recruitment$model <- NULL
fit_recruitment_trend$model <- NULL
fit_survival$model <- NULL
fit_survival_trend$model <- NULL
fit_recruitment_ml$model <- NULL
fit_survival_ml$model <- NULL

usethis::use_data(fit_recruitment, fit_recruitment_trend,
  fit_survival, fit_survival_trend,
  fit_survival_ml, fit_recruitment_ml,
  internal = TRUE, overwrite = TRUE
)
