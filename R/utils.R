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

check_output_format <- function(file) {
  lines <- rmarkdown:::read_lines_utf8(file = file, encoding = getOption("encoding"))
  output_format <- try(rmarkdown:::output_format_from_yaml_front_matter(lines)$name)
  if (inherits(output_format, "try-error")) {
    file.remove(file)
    stop("Make sure the YAML header contains no errors. Beware of erroneous indentation.")
  }
  if (!grepl("html_", output_format)) {
    file.remove(file)
    stop("Make sure to specify an HTML output format in the YAML header of your Markdown file.")
  }
}

msg <- function(msg, quiet) {
  if (is.logical(quiet) && !quiet) {
    message(msg)
  }
}
