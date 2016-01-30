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

#' Create example .Rmd file in the current working directory
#'
#' @export
build_example <- function() {
  fname <- "example.Rmd"
  file.copy(from = file.path(system.file(package = "tutorial"), fname), to = file.path(getwd(), fname))
  message(sprintf("Example file %s created in current working directory.\nExecute render(\"%s\") to convert to %s readble HTML.", fname, fname, project_alias))
}
