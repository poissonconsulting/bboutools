test_that(".check_attached works", {
  # nimble is attached during tests, so this should pass
  expect_silent(.check_attached())

  # simulate nimble not being attached
  expect_error(.check_attached(search_path = character(0)), "nimble")
})
