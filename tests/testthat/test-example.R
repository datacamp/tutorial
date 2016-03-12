context("example")

test_that("add tests", {
  filename <- "example.Rmd"
  unlink(filename)
  expect_false(filename %in% dir())
  build_example()
  expect_true(filename %in% dir())
  expect_true(any(grepl("Example \\(R\\)", readLines(filename))))
  unlink(filename)

  filename <- "example.Rmd"
  unlink(filename)
  expect_false(filename %in% dir())
  build_example(lang = "python")
  expect_true(filename %in% dir())
  expect_true(any(grepl("Example \\(Python\\)", readLines(filename))))
  unlink(filename)
})


