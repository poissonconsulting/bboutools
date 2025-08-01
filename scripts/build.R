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

roxygen2md::roxygen2md()
styler::style_pkg(filetype = c("R", "Rmd"))

# lintr::lint_package()
lintr::lint_package(linters = lintr::linters_with_defaults(
  line_length_linter = lintr::line_length_linter(1000),
  object_name_linter = lintr::object_name_linter(regexes = ".*"))
)

devtools::test()
devtools::document()

pkgdown::build_home()

devtools::check()
