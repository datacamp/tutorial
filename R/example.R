# To pass R CMD CHECK, we want to make file.edit available. You don't want to
# import file.edit from the utils package explicitly inside build_example,
# because then it doesn't work as you'd expect inside RStudio (it opens the file
# in a new window)
utils::globalVariables("file.edit")

#' Create example .Rmd file in the current working directory
#'
#' Create the file \code{example.Rmd} in your current working directory.
#' This R Markdown files contains example code chunks that can be converted to
#' interactive R playgrounds.
#'
#' @param open Open the file after building the example?
#'
#' @export
build_example <- function(open = TRUE) {
  fname <- "example.Rmd"
  dest <- file.path(getwd(), fname)
  file.copy(from = file.path(system.file(package = "tutorial"), fname),
            to = dest, overwrite = TRUE)
  msg <- paste0("Example file 'example.Rmd' created ",
                "in current working directory.\n",
                "Simply knit the file.")
  message(sprintf(msg, project_alias))
  if (isTRUE(open)) {
    file.edit(dest)
  }
  return(invisible(fname))
}
