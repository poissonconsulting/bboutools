.check_attached <- function(search_path = search()) {
  if (!"package:nimble" %in% search_path || !"package:nimbleQuad" %in% search_path) {
    cli::cli_abort(c(
      "{.pkg nimble} and {.pkg nimbleQuad} must be attached to the search path for model fitting.",
      "i" = "Use {.code library(bboutools)} instead of {.code bboutools::}."
    ))
  }
}
