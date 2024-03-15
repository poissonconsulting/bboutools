remove_missing <- function(x, quiet = FALSE, cols = names(x)) {
  x2 <- tidyr::drop_na(x, tidyr::all_of(cols))
  rows <- nrow(x) - nrow(x2)
  if (rows > 0 && !quiet) {
    message(glue("Removed {rows} rows with missing values."))
  }
  x2
}

remove_0 <- function(x, col = "StartTotal", quiet = FALSE) {
  x2 <- x[x[[col]] != 0, ]
  rows <- nrow(x) - nrow(x2)
  if (rows > 0 && !quiet) {
    message(glue("Removed {rows} rows with '{col}' value of 0."))
  }
  x2
}

remove_sum0 <- function(x, cols = c("Cows", "Bulls", "UnknownAdults", "Yearlings", "Calves"), quiet = FALSE) {
  x2 <- x[rowSums(x[cols]) != 0, ]
  rows <- nrow(x) - nrow(x2)
  if (rows > 0 && !quiet) {
    message(glue("Removed {rows} rows where columns {chk::cc(cols, ' and ')} sum to 0."))
  }
  x2
}
