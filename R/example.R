#' Create example .Rmd file in the current working directory
#'
#' @export
build_example <- function(lang = c("r", "python")) {
  lang <- match.arg(lang)
  fname <- sprintf("example_%s.Rmd", lang)
  dest <- file.path(getwd(), "example.Rmd")
  file.copy(from = file.path(system.file(package = "tutorial"), fname), to = dest, overwrite = TRUE)
  message(sprintf(paste0("Example file 'example.Rmd' created in current working directory.\n",
                         "Execute render(\"example.Rmd\") to convert to %s readble HTML."),
                  project_alias))
}
