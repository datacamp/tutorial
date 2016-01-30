#' Create example .Rmd file in the current working directory
#'
#' @export
build_example <- function() {
  fname <- "example.Rmd"
  file.copy(from = file.path(system.file(package = "tutorial"), fname), to = file.path(getwd(), fname))
  message(sprintf("Example file %s created in current working directory.\nExecute render(\"%s\") to convert to %s readble HTML.", fname, fname, project_alias))
}
