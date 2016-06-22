allowed_elements <- c("pre-exercise-code", "sample-code", "solution", "sct", "hint")
required_elements <- c("sample-code")
project_alias <- "DataCamp Light"

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

tutorial_accessors <- function() {
  dc_data <- list()

  get = function(name) {
    if (missing(name)) {
      dc_data
    } else {
      dc_data[[name]]
    }
  }

  set = function(...) {
    dots = list(...)
    dc_data <<- merge(dots)
    invisible(NULL)
  }

  clear = function() {
    dc_data <<- list()
    invisible(NULL)
  }

  merge = function(values) merge_list(dc_data, values)

  list(get = get, set = set, clear = clear)
}

merge_list = function(x, y) {
  x[names(y)] = y
  x
}

tutorial <- tutorial_accessors()
