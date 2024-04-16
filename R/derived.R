extract_lik <- function(x) {
  x <- as.character(model_code(x))
  x <- x[grepl("log|logit", x)]
  regmatches(x, regexpr("b0([^\\\n]*)", text = x))
}

extract_lik_year <- function(x) {
  x <- extract_lik(x)
  gsub(" + bMonth[Month[i]]", "", x, fixed = TRUE)
}

derived_expr_survival <- function(fit, year, month) {
  lik_year <- extract_lik_year(fit)
  if (year) {
    if (month) {
      pred <- paste0("logit(ilogit(", lik_year, " + bMonth[Month[i]])^12)")
    } else {
      pred <- paste0("logit(ilogit(", lik_year, ")^12)")
    }
  } else {
    if (month) {
      pred <- "logit(ilogit(b0 + bMonth[Month[i]])^12)"
    } else {
      pred <- "logit(ilogit(b0)^12)"
    }
  }
  paste0("for(i in 1:length(Annual)) {
  logit(prediction[i]) <- ", pred, "\n}")
}

derived_expr_recruitment <- function(fit, year) {
  lik <- "b0"
  if (year) {
    lik <- extract_lik(fit)
  }
  paste0("for(i in 1:length(Annual)) {
  logit(prediction[i]) <- ", lik, "\n}")
}

derived_expr_recruitment_trend <- function() {
  "for(i in 1:length(Annual)) {
  logit(prediction[i]) <- b0 + bYear * Year[i]\n}"
}

derived_expr_survival_trend <- function() {
  "for(i in 1:length(Annual)) {
  logit(prediction[i]) <- logit(ilogit(b0 + bYear * Year[i])^12)\n}"
}
