allowed_elements <- c("language", "pre-exercise-code", "sample-code", "solution", "sct", "hint")
required_elements <- c("sample-code")
project_alias <- "DataCamp Light"
script_tag <- "<script src=\"https://cdn.datacamp.com/datacamp-light-latest.min.js\"></script>\n"

cpaste <- function(x) {
  paste(x, collapse = "\n")
}

spaste <- function(...) {
  paste(..., sep = "\n")
}

collapse <- function(x, conn = " and ") {
  if (length(x) > 1) {
    n <- length(x)
    last <- c(n - 1, n)
    collapsed <- paste(x[last], collapse = conn)
    collapsed <- paste(c(x[-last], collapsed), collapse = ", ")
  } else collapsed <- x
  collapsed
}

#' @importFrom markdown markdownToHTML
to_html <- function(x) {
  html <- markdownToHTML(text = x, fragment.only = TRUE)
  #remove surrounding <p> tags
  html <- gsub("^\\s*<p>(.*?)</p>\\s*$", "\\1", html)
  # remove trailing newlines
  html <- gsub("^(.*?)\\s*$", "\\1", html)
  html
}
