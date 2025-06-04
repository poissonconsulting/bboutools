# Copyright 2022-2023 Integrated Ecological Research and Poisson Consulting Ltd.
# Copyright 2024 Province of Alberta
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
