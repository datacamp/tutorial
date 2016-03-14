context("example")

test_that("add tests", {
  filename <- "example.Rmd"
  unlink(filename)
  expect_false(filename %in% dir())
  build_example()
  expect_true(filename %in% dir())
  expect_true(any(grepl("Example Document", readLines(filename))))
  unlink(filename)
})


