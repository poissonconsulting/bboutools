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

test_that("substitute_prior_values replaces symbolic names", {
  code <- quote({
    b0 ~ dnorm(b0_mu, sd = b0_sd)
    sAnnual ~ dexp(sAnnual_rate)
  })
  constants <- c(b0_mu = 3, b0_sd = 10, sAnnual_rate = 1)
  result <- substitute_prior_values(code, constants)
  result_text <- deparse(result)
  expect_false(any(grepl("b0_mu", result_text)))
  expect_false(any(grepl("b0_sd", result_text)))
  expect_false(any(grepl("sAnnual_rate", result_text)))
  expect_true(any(grepl("\\b3\\b", result_text)))
  expect_true(any(grepl("\\b10\\b", result_text)))
})

test_that("substitute_prior_values ignores names not in code", {
  code <- quote({
    b0 ~ dnorm(b0_mu, sd = b0_sd)
  })
  constants <- c(b0_mu = 3, b0_sd = 10, not_in_code = 99)
  result <- substitute_prior_values(code, constants)
  result_text <- deparse(result)
  expect_false(any(grepl("99", result_text)))
})

test_that("clean_model_code unwraps redundant braces", {
  # Simulates NIMBLE's if/else resolution wrapping branches in { }
  code <- quote({
    for (k in 1:nPopulation) {
      b0[k] ~ dnorm(3, sd = 10)
    }
    {
      adult_female_proportion <- 0.65
    }
    {
      sAnnual ~ dexp(1)
      for (i in 1:nAnnual) {
        bAnnual[i] ~ dnorm(0, sd = sAnnual)
      }
    }
  })
  result <- clean_model_code(code)
  result_text <- deparse(result)
  # The for loop, assignment, and sAnnual block should all be at the same level
  # No line should be just "{"  or "}" wrapped around a single block
  # Count top-level expressions (children of outer { })
  n_children <- length(result) - 1L # subtract the `{` symbol
  # Originally: for, { assignment }, { sAnnual + for }
  # After cleaning: for, assignment, sAnnual, for = 4 children
  expect_equal(n_children, 4L)
})

test_that("clean_model_code handles deeply nested braces", {
  code <- quote({
    {{ x <- 1 }}
    y <- 2
  })
  result <- clean_model_code(code)
  n_children <- length(result) - 1L
  expect_equal(n_children, 2L)
})

test_that("clean_model_code preserves non-brace expressions", {
  code <- quote({
    for (i in 1:n) {
      x[i] ~ dnorm(0, 1)
    }
  })
  result <- clean_model_code(code)
  expect_identical(result, code)
})
