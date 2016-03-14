#' Create example .Rmd file in the current working directory
#'
#' Create the file \code{example.Rmd} in your current working directory.
#' This R Markdown files contains example code chunks that can be converted to
#' R and Python interactive exercise with the \code{\link{render}} function.
#'
#' @export
build_example <- function() {
  fname <- "example.Rmd"
  dest <- file.path(getwd(), fname)
  file.copy(from = file.path(system.file(package = "tutorial"), fname), to = dest, overwrite = TRUE)
  message(sprintf(paste0("Example file 'example.Rmd' created in current working directory.\n",
                         "Execute render(\"example.Rmd\") to convert to %s readble HTML."),
                  project_alias))
  return(invisible(fname))
}
