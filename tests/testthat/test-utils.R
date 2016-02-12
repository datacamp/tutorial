context("utils")

test_that("cpaste and spaste work as expected", {
  expect_equal(cpaste(c("a", "b", "c")), "a\nb\nc")
  expect_equal(cpaste(c("a")), "a")
  expect_equal(spaste("a", "b", "c"), "a\nb\nc")
  expect_equal(spaste("a"), "a")
})

test_that("collapse work as expected", {
  expect_equal(collapse(c("a")), "a")
  expect_equal(collapse(c("a", "b")), "a and b")
  expect_equal(collapse(c("a", "b", "c")), "a, b and c")
  expect_equal(collapse(c("a", "b", "c"), conn = " or "), "a, b or c")
})

test_that("to_html works as expected", {
  expect_equal(to_html("test"), "test")
  expect_equal(to_html("_test_"), "<em>test</em>")
  expect_equal(to_html("__test__"), "<strong>test</strong>")
  expect_equal(to_html("# title\ntest"), "<h1>title</h1>\n\n<p>test</p>")
})

