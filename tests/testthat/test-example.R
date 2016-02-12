context("example")

test_that("add tests", {
  filename <- "example.Rmd"
  unlink(filename)
  expect_false(filename %in% dir())
  build_example()
  expect_true(filename %in% dir())
  unlink(filename)
})
