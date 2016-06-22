
header <- '---\ntitle: "Example Document"\nauthor: "Your name here"\noutput: html_document\n---\n\n'
start <- "```{r, include=FALSE}\ntutorial::go_interactive()\n```\n"
text1 <- "this is a test\n"
pec1 <- "```{r, ex='test', type='pre-exercise-code'}\n# pec\n```\n"
sample1 <- "```{r, ex='test', type=\"sample-code\"}\n# sample\n```\n"
sample1_no_type <- "```{r, ex='test'}\n# sample\n```\n"
solution1 <- "```{r, ex='test', type=\"solution\"}\n# solution\n```\n"
sct1 <- "```{r, ex='test', type=\"sct\"}\n# sct\n```\n"
hint1 <- "```{r, ex='test', type=\"hint\"}\nHere's a hint\n```\n"
text2 <- "text with code block\n\n```{r}\nhead(mtcars)\n```\n"

doc1 <- spaste(header, start, text1, pec1, sample1, solution1, sct1, hint1, text2)
doc2 <- spaste(header, start, text1, sample1, pec1, solution1, sct1, hint1, text2)
doc3 <- spaste(header, start, text1, sample1, solution1, pec1, sct1, hint1, text2)
doc4 <- spaste(header, start, text1, sample1, solution1, sct1, pec1, hint1, text2)
doc5 <- spaste(header, start, text1, sample1, text2, solution1, sct1, hint1, pec1)
doc6 <- spaste(header, start, text1, sample1, solution1, text2, sct1, hint1, pec1)
doc7 <- spaste(header, start, text1, sample1, solution1, sct1, text2, hint1, pec1)

# incorrect ones
doc8 <- spaste(doc7, "```{r, ex='test', type=\"retteketet\", eval = FALSE}\n# solution\n```\n")
doc9 <- spaste(doc7, "```{r, ex='hutetetut', type = \"retteketkjetket\"}\n# solution\n```\n")

# fiddle: only sample-code
doc10 <- spaste(header, start, text1, sample1)
doc11 <- spaste(header, start, text1, sample1_no_type)

library(rjson)
library(base64enc)
extract_parts <- function(file) {
  html <- readLines(file)
  before_ind <- which(html == "<div data-datacamp-exercise data-lang=\"r\" data-encoded=\"true\">")
  if (length(before_ind) == 0) {
    return(NULL)
  } else {
    code <- html[before_ind[1] + 1]
    rjson::fromJSON(rawToChar(base64enc::base64decode(code)))
  }
}


if (rmarkdown::pandoc_available()) {
  context("renderer")

  test_that("renderer works as expected", {

    test_it <- function(doc) {
      input <- "test.Rmd"
      write(doc, file = input)
      output <- rmarkdown::render(input, quiet = TRUE)
      parts <- extract_parts(output)
      nms <- names(parts)
      expect_true("pre_exercise_code" %in% nms)
      expect_true("sample" %in% nms)
      expect_true("solution" %in% nms)
      expect_true("sct" %in% nms)
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
      expect_error(rmarkdown::render(input, quiet = TRUE))
      unlink(input)
    }

    test_it_error(doc8)
    test_it_error(doc9)
  })

  test_that("renderer works as expected in fiddle-form", {

    test_it <- function(doc) {
      input <- "test.Rmd"
      write(doc, file = input)
      rmarkdown::render(input, quiet = TRUE)
      output <- "test.html"
      parts <- extract_parts(output)
      nms <- names(parts)
      expect_true("sample" %in% nms)
      unlink(input)
      unlink(output)
    }

    test_it(doc10)
    test_it(doc11)

  })

  context("incorrect_formats")

  test_that("resilient against incorrect formats", {
    input <- "test.Rmd"

    check <- function() {
      output <- rmarkdown::render(input, quiet = TRUE)
      parts <- extract_parts(output)
      nms <- names(parts)
      expect_true("sample" %in% nms)
      unlink(input)
      unlink(output)
    }

    rest <- c(header, start, text1, sample1)
    write(c("---", "title: Example Document", "author: Filip", "---\n\n", rest), file = input)
    check()

    write(c("---", "title: Example Document", "author: Filip", "output: html_document", "---\n", rest), file = input)
    check()

    write(c("---", "title: Example Document", "author: Filip", "output: html_vignette", "---\n", rest), file = input)
    check()

    # write(c("---", "title: Example Document", "author: Filip", "output: pdf_document", "---\n", rest), file = input)
    # expect_error(rmarkdown::render(input, quiet = TRUE))

  })

}
