context("utils")

test_that("utility functions work as expected", {
  expect_equal(collapse(c("a")), "a")
  expect_equal(collapse(c("a", "b")), "a and b")
  expect_equal(collapse(c("a", "b", "c")), "a, b and c")
  expect_equal(collapse(c("a", "b", "c"), conn = " or "), "a, b or c")
})
