#' Create DataCamp Light readable HTML file
#'
#' Currently only supports passing an input file, no other input methods possible.
#'
#' @param input path to .Rmd file that you want to convert.
#' @param ... Other arguments that are passed to \code{rmarkdown::render}.
#'
#' @importFrom rmarkdown render
#' @export
render <- function(input, ...) {

  lines <- readLines(input)

  message(sprintf("Finding %s code chunks ...", project_alias))
  begin_patt <- "^[\t >]*```+\\s*\\{[.]?[a-zA-Z]+.*ex\\s*=(.*?)\\s*,\\s*type\\s*=(.*?)\\}\\s*$"
  end_patt <- "^[\t >]*```+\\s*$"
  starts <- which(grepl(begin_patt, lines))
  ends <- which(grepl(end_patt, lines))

  message("Dividing document in code chunks and inline chunks ...")
  if(1 %in% starts) stop(sprintf("Don't start your .Rmd file with a %s code chunk.", project_alias))
  current_state <- "inline"
  start <- 1
  blocks <- list()
  for(i in 2:length(lines)) {
    if(i %in% starts) {
      if(current_state == "inline") {
        blocks <- c(blocks, list(list(content = cpaste(lines[start:(i-1)]), form = "inline")))
      }
      ex = gsub(begin_patt, "\\1", lines[i])
      type = gsub(begin_patt, "\\2", lines[i])
      block_id <- which(sapply(blocks, function(x) x$form == "code" && x$ex == ex))
      new_el <- list("")
      names(new_el) <- type
      if(length(block_id) == 0) {
        blocks <- c(blocks, list(list(form = "code", ex = ex, els = list())))
        block_id <- length(blocks)
      }
      start <- i + 1
      current_state = "code"
    }

    if(i %in% ends) {
      if(current_state == "code") {
        blocks[[block_id]]$els[[type]] <- cpaste(lines[start:(i-1)])
        current_state <- ifelse((i + 1) %in% starts, "code", "inline")
        start <- i + 1
      }
    }
  }
  # If more inline stuff, also add it.
  if(start < length(lines)) {
    blocks <- c(blocks, list(list(content = cpaste(lines[start:length(lines)]), form = "inline")))
  }

  message(sprintf("Assembling new document ...", project_alias))
  lut <- list()
  new_doc <- ""
  for(block in blocks) {
    if(block$form == "inline") {
      new_doc <- spaste(new_doc, block$content)
    } else {
      # Do some checks on the chunks
      if(!all(required_elements %in% names(block$els))) {
        stop(sprintf("%s does not contain all required elements. You need %s", block$ex, collapse(required_elements)))
      }
      if(length(block$els[allowed_elements]) < length(block$els)) {
        stop(sprintf("%s contains elements that are not understood by %s.", ex_name, project_alias))
      }
      html <- build_exercise_html(block$els)
      key <- sprintf("dc_light_exercise_%s", block$ex)
      lut[[key]] <- html
      new_doc <- spaste(new_doc, key)
    }
  }

  message("Convert Rmd to HTML using R Markdown ...")
  new_input <- "converted.Rmd"
  write(new_doc, file = new_input)
  args = list(...)
  args$output_format = "html_document"
  args$input = new_input
  output_file <- gsub("\\.[R|r]md$", ".html", input)
  args$output_file = output_file
  args$quiet = TRUE
  do.call(rmarkdown::render, args = args)
  file.remove(new_input)

  message("Finishing up ... ")
  htmlfile <- paste(readLines(output_file), collapse = "\n")
  htmlfile <- paste0("<script src=\"https://cdn.datacamp.com/datacamp-light-1.0.0.min.js\"></script>\n\n",htmlfile)
  for(i in seq_along(lut)) {
    htmlfile <- gsub(sprintf("<p>%s</p>", names(lut)[i]), lut[i], htmlfile)
  }
  write(htmlfile, file = output_file)
  message(sprintf("Done! Your %s readable HTML file is available as %s.", project_alias, output_file))
}

build_exercise_html <- function(els) {
  els <- els[allowed_elements[allowed_elements %in% names(els)]]
  html <- "<div data-datacamp-exercise data-lang=\"r\">"
  for(j in seq_along(els)) {
    el <- els[[j]]
    type <- names(els)[j]
    block <- ifelse(type == "hint", "<p data-type=\"%s\">%s</p>", "<code data-type=\"%s\">\n%s\n</code>")
    if(type == "hint") el <- to_html(el)
    html <- paste(html, sprintf(block, type, el), sep = "\n")
  }
  paste(html, "</div>", sep = "\n")
}
