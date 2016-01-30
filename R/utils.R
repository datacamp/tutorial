collapse <- function(x, conn = " and ") {
  if (length(x) > 1) {
    n <- length(x)
    last <- c(n-1, n)
    collapsed <- paste(x[last], collapse = conn)
    collapsed <- paste(c(x[-last], collapsed), collapse = ", ")
  } else collapsed <- x
  collapsed
}

#' @importFrom markdown markdownToHTML
to_html <- function(x, trim = FALSE) {
  html <- markdownToHTML(text = x, fragment.only = TRUE)
  if(trim) html <- gsub("<p>(.*?)</p>", "\\1", html) #remove <p> tags, coded by front end.
  html
}

allowed_elements <- c("pre-exercise-code", "sample-code", "solution", "sct", "hint")
required_elements <- c("sample-code", "solution", "sct")
project_alias <- "DataCamp Light"
