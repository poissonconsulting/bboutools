z_score <- function(conf_level) {
  qnorm(1 - (1 - conf_level) / 2)
}

ci_lower <- function(x, se, conf_level) {
  z <- z_score(conf_level)
  x - z * se
}

ci_upper <- function(x, se, conf_level) {
  z <- z_score(conf_level)
  x + z * se
}

.stderr <- function(x) {
  c(
    x$summary$params$stdErrors,
    x$summary$randomEffects$stdErrors
  )
}

transform_cols <- function(x, terms, transform = exp, cols = c("estimate", "lower", "upper")) {
  for (term in terms) {
    x[x$term == term, cols] <- map(x[x$term == term, cols], transform)
  }
  x
}

#' @export
generics::tidy

#' Get Tidy Tibble from bboufit Object.
#'
#' Get a tidy tibble of the coefficient estimates and
#' confidence intervals from Bayesian model fit.
#'
#' @inheritParams params
#' @return A tibble of the tidy coefficient summary.
#' @family generics
#' @seealso [`coef.bboufit()`]
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival(bboudata::bbousurv_a)
#'   tidy(fit)
#' }
tidy.bboufit <- function(x,
                         conf_level = 0.95,
                         estimate = median,
                         sig_fig = 3,
                         include_random_effects = TRUE,
                         ...) {
  .chk_fit(x)
  chk_range(conf_level, c(0, 1))
  chk_is(estimate, "function")
  chk_whole_number(sig_fig)
  chk_flag(include_random_effects)

  samples <- samples(x)
  coef <-
    mcmcr::coef(samples, conf_level = conf_level, estimate = estimate)
  coef$svalue <- NULL
  if (!include_random_effects) {
    coef <- exclude_random(coef)
  }

  coef <- signif_cols(coef, sig_fig = sig_fig)

  tibble::as_tibble(coef)
}

#' Get Tidy Tibble from bboufit_ml Object.
#'
#' Get a tidy tibble of the coefficient estimates and
#' confidence intervals from Maximum Likelihood model fit.
#'
#' @inheritParams params
#' @return A tibble of the tidy coefficient summary.
#' @family generics
#' @seealso [`coef.bboufit_ml()`]
#' @export
#' @examples
#' if (interactive()) {
#'   fit <- bb_fit_survival_ml(bboudata::bbousurv_a)
#'   tidy(fit)
#' }
tidy.bboufit_ml <-
  function(x,
           conf_level = 0.95,
           sig_fig = 3,
           include_random_effects = TRUE,
           ...) {
    .chk_fit_ml(x)
    chk_range(conf_level, c(0, 1))
    chk_whole_number(sig_fig)
    chk_flag(include_random_effects)

    coef <- summary_ml(x)
    coef$parameter <- NULL
    se <- .stderr(x)

    coef$lower <- ci_lower(coef$estimate, se, conf_level)
    coef$upper <- ci_upper(coef$estimate, se, conf_level)
    terms <- coef$term
    terms_exp <- terms[terms %in% c("sAnnual", "sMonth")]
    terms_ilogit <- terms[terms %in% c("adult_female_proportion")]
    coef <- transform_cols(coef, terms_exp, transform = exp)
    coef <- transform_cols(coef, terms_ilogit, transform = nimble::ilogit)
    coef <- signif_cols(coef, sig_fig = sig_fig)
    if (!include_random_effects) {
      coef <- exclude_random(coef)
    }

    tibble::as_tibble(coef)
  }
