#' Create DataCamp Light readable HTML file
#'
#' Wrapper around \code{rmarkdown::render} function, that converts
#' special code chunks where the \code{ex} and \code{type} options are specified,
#' into interactive exercises on the resulting HTML page.
#' Have a look at the file \code{\link{build_example}} generates to
#' learn more about the format of the code chunks.
#'
#' @param input path to .Rmd file that you want to convert.
#' @param open whether or not to open the resulting HTML file in your default browser (default is TRUE)
#' @param quiet hide status messages while building the HTML file?
#' @param ... Other arguments that are passed to \code{rmarkdown::render}.
#'
#' @return file name of the output file
#'
#' @examples
#' \dontrun{
#' build_example()
#' render("example.Rmd")
#' }
#'
#' @importFrom rmarkdown render
#' @importFrom utils browseURL
#' @export
render <- function(input, open = TRUE, quiet = FALSE, ...) {

  lines <- readLines(input)
  blocks <- parse_lines(lines)

  msg("Assembling new document ...", quiet)

  lut <- list()
  new_doc <- ""
  for (block in blocks) {
    if (block$form == "inline") {
      new_doc <- spaste(new_doc, block$content)
    } else {
      # Do some checks on the chunks
      if (!all(required_elements %in% names(block$els))) {
        stop(sprintf("%s does not contain all required elements. You need %s", block$ex, collapse(required_elements)))
      }
      if (!all(names(block$els) %in% allowed_elements)) {
        stop(sprintf("%s contains elements that are not understood by %s.", block$ex, project_alias))
      }
      html <- build_exercise_html(block$lang, block$els)
      key <- sprintf("dc_light_exercise_%s", block$ex)
      lut[[key]] <- html
      new_doc <- spaste(new_doc, "", key) # need this new line for obscure reasons
    }
  }

  msg("Convert Rmd to HTML using R Markdown ...", quiet)
  new_input <- "converted.Rmd"
  write(new_doc, file = new_input)
  args = list(...)
  args$input = new_input
  check_output_format(new_input)

  output_file <- gsub("\\.[R|r]md$", ".html", input)
  args$output_file = output_file
  args$quiet = quiet
  do.call(rmarkdown::render, args = args)
  file.remove(new_input)

  htmlfile <- paste(readLines(output_file), collapse = "\n")
  file.remove(output_file)
  htmlfile <- paste0("<script src=\"https://cdn.datacamp.com/datacamp-light-1.0.0.min.js\"></script>\n\n",htmlfile)
  for (i in seq_along(lut)) {
    htmlfile <- gsub(sprintf("<p>%s</p>", names(lut)[i]), lut[i], htmlfile)
  }
  write(htmlfile, file = output_file)

  msg(sprintf("Done! Your %s readable HTML file is available as %s.", project_alias, output_file), quiet)
  if (open) {
    msg(sprintf("Opening %s in your browser ...", output_file), quiet)
    browseURL(output_file)
  }

  return(output_file)
}


build_exercise_html <- function(lang, els) {
  els <- els[allowed_elements[allowed_elements %in% names(els)]]
  html <- sprintf("<div data-datacamp-exercise data-lang=\"%s\">", lang)
  for (j in seq_along(els)) {
    el <- els[[j]]
    type <- names(els)[j]
    block <- ifelse(type == "hint", "<div data-type=\"%s\">%s</div>", "<code data-type=\"%s\">\n%s\n</code>")
    if (type == "hint") el <- to_html(el)
    html <- paste(html, sprintf(block, type, el), sep = "\n")
  }
  paste(html, "</div>", sep = "\n")
}



