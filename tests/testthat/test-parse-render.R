text1 <- "this is a test\n"
pec1 <- "```{r, ex='test', type='pre-exercise-code'}\n# pec\n```\n"
sample1 <- "```{r, ex='test', type=\"sample-code\", echo = FALSE}\n# sample\n```\n"
solution1 <- "```{r, ex='test', type=\"solution\", eval = FALSE}\n# solution\n```\n"
sct1 <- "```{r, include=FALSE, ex='test', type=\"sct\"}\n# sct\n```\n"
hint1 <- "```{r, echo = TRUE, ex='test', type=\"hint\"}\nHere's a hint\n```\n"
text2 <- "text with code block\n\n```{r, eval = FALSE}\nhead(mtcars)\n```\n"

doc1 <- spaste(text1, pec1, sample1, solution1, sct1, hint1, text2)
doc2 <- spaste(text1, sample1, pec1, solution1, sct1, hint1, text2)
doc3 <- spaste(text1, sample1, solution1, pec1, sct1, hint1, text2)
doc4 <- spaste(text1, sample1, solution1, sct1, pec1, hint1, text2)
doc5 <- spaste(text1, sample1, text2, solution1, sct1, pec1, hint1)
doc6 <- spaste(text1, sample1, solution1, text2, sct1, pec1, hint1)
doc7 <- spaste(text1, sample1, solution1, sct1, text2, pec1, hint1)

# incorrect ones
doc8 <- spaste(doc7, "```{r, ex='test', type=\"retteketet\", eval = FALSE}\n# solution\n```\n")
doc9 <- spaste(doc7, "```{r, ex='hutetetut', type = \"retteketkjetket\"}\n# solution\n```\n")

# fiddle: only sample-code
doc10 <- spaste(text1, sample1)

context("parse_lines")

test_that("parse_lines works as expected", {

  test_it <- function(doc) {
    x <- parse_lines(strsplit(doc, "\n")[[1]])
    expect_true(is.list(x))
    expect_true(is.list(x[[2]]))
    expect_equal(x[[2]]$form, "code")
    expect_equal(x[[2]]$ex, "test")
    expect_true(is.list(x[[2]]$els))
    expect_equal(x[[2]]$els[["pre-exercise-code"]], "# pec")
    expect_equal(x[[2]]$els[["sample-code"]], "# sample")
    expect_equal(x[[2]]$els[["solution"]], "# solution")
    expect_equal(x[[2]]$els[["sct"]], "# sct")
    expect_equal(x[[length(x)]]$form, "inline")
  }

  test_it(doc1)
  test_it(doc2)
  test_it(doc3)
  test_it(doc4)
  test_it(doc5)
  test_it(doc6)
  test_it(doc7)
})

context("renderer")

test_that("renderer works as expected", {

  test_it <- function(doc) {
    input <- "test.Rmd"
    write(doc, file = input)
    output <- render(input, open = FALSE, quiet = TRUE)
    expect_true(output %in% dir())
    html_lines <- readLines(output)
    expect_true(any(grepl("<div data-datacamp-exercise data-lang=\"r\">", html_lines)))
    expect_true(any(grepl("<code data-type=\"pre-exercise-code\">", html_lines)))
    expect_true(any(grepl("<code data-type=\"sample-code\">", html_lines)))
    expect_true(any(grepl("<code data-type=\"solution\">", html_lines)))
    expect_true(any(grepl("<code data-type=\"sct\">", html_lines)))

    unlink(input)
    unlink(output)
  }

  test_it(doc1)
  test_it(doc2)
  test_it(doc3)
  test_it(doc4)
  test_it(doc5)
  test_it(doc6)
  test_it(doc7)


  test_it_error <- function(doc) {
    input <- "test.Rmd"
    write(doc, file = input)
    expect_error(render(input, open = FALSE, quiet = TRUE))
    unlink(input)
  }

  test_it_error(doc8)
  test_it_error(doc9)
})

test_that("renderer works as expected in fiddle-form", {
  input <- "test.Rmd"
  write(doc10, file = input)
  render(input, open = FALSE, quiet = TRUE)
  output <- "test.html"
  expect_true(output %in% dir())
  html_lines <- readLines(output)
  expect_true(any(grepl("<code data-type=\"sample-code\">", html_lines)))
  unlink(input)
  unlink(output)
})

context("parse_lines")

test_that("resilient against incorrect formats", {
  input <- "test.Rmd"

  write(c("---", "title: Example Document", "author: Filip", "---\n", doc10), file = input)
  output <- render(input, open = FALSE, quiet = TRUE)
  expect_true(any(grepl("<code data-type=\"sample-code\">", readLines(output))))
  unlink(input)
  unlink(output)

  write(c("---", "title: Example Document", "author: Filip", "output: html_document", "---\n", doc10), file = input)
  output <- render(input, open = FALSE, quiet = TRUE)
  expect_true(any(grepl("<code data-type=\"sample-code\">", readLines(output))))
  unlink(input)
  unlink(output)

  write(c("---", "title: Example Document", "author: Filip", "output: html_vignette", "---\n", doc10), file = input)
  output <- render(input, open = FALSE, quiet = TRUE)
  expect_true(any(grepl("<code data-type=\"sample-code\">", readLines(output))))
  unlink(input)
  unlink(output)

  write(c("---", "title: Example Document", "author: Filip", "output: pdf_document", "---\n"), file = input)
  expect_error(render(input, open = FALSE, quiet = TRUE))
  unlink(input)
  unlink(output)
})

