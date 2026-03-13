# Copyright 2025 Environment and Climate Change Canada
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

.check_attached <- function(search_path = search()) {
  if (!"package:nimble" %in% search_path || !"package:nimbleQuad" %in% search_path) {
    cli::cli_abort(c(
      "{.pkg nimble} and {.pkg nimbleQuad} must be attached to the search path for model fitting.",
      "i" = "Use {.code library(bboutools)} instead of {.code bboutools::}."
    ))
  }
}
