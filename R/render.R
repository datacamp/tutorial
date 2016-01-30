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

  dl_starts <- starts
  dl_ends <- c()
  for(sline in starts) {
    for(eline in ends) {
       if(sline < eline) {
          dl_ends <- c(dl_ends, eline)
          break
       }
    }
  }

  message("Dividing document in code chunks and inline chunks ...")
  blocks <- list(list(start = 1, form = "inline"))
  for(i in 1:length(lines)) {
    if(i %in% starts) {
      blocks[[length(blocks)]]$end = i - 1
      blocks <- c(blocks, list(list(start = i, form = "code")))
    }

    if(i %in% ends) {
      blocks[[length(blocks)]]$end = i
      blocks <- c(blocks, list(list(start = i+1, form = "inline")))
    }
  }
  blocks[[length(blocks)]]$end = length(lines)


  message(sprintf("Collecting information for %s exercises ...", project_alias))
  ex_list = list()
  for(i in seq_along(blocks)) {
    if(blocks[[i]]$form == "inline") next
    cb <- lines[blocks[[i]]$start: blocks[[i]]$end]
    ex = gsub(begin_patt, "\\1", cb[1])
    type = gsub(begin_patt, "\\2", cb[1])
    if(is.null(ex_list[[ex]])) {
      ex_list[[ex]] = list()
    }
    ex_list[[ex]][[type]] = list()
    ex_list[[ex]][[type]][["content"]] = paste(cb[2:(length(cb)-1)], collapse = "\n")
    blocks[[i]]$type = type
    blocks[[i]]$ex = ex
    # ex_list[[ex]][[type]][["block_num"]] = i
  }

  message(sprintf("Preparing %s readable HTML ...", project_alias))
  for(i in seq_along(ex_list)) {
    ex_name <- names(ex_list)[i]
    ex <- ex_list[[i]]
    if(!all(required_elements %in% names(ex))) {
      stop(sprintf("%s does not contain all required elements. You need %s", ex_name, collapse(required_elements)))
    }
    if(length(ex[allowed_elements]) < length(ex)) {
      stop(sprintf("%s contains elements that are not understood by %s.", ex_name, project_alias))
    }

    # order the ex elements correctly
    ex <- ex[allowed_elements[allowed_elements %in% names(ex)]]
    html <- "<div data-datacamp-exercise data-lang=\"r\">"
    for(j in seq_along(ex)) {
      el <- ex[[j]]
      type <- names(ex)[j]
      block <- ifelse(type == "hint", "<p data-type=\"%s\">%s</p>", "<code data-type=\"%s\">\n%s\n</code>")
      if(type == "hint") el$content <- to_html(el$content, trim = TRUE)
      html <- paste(html, sprintf(block, type, el$content), sep = "\n")
    }
    html <- paste(html, "</div>", sep = "\n")
    ex_list[[i]]$html = html
  }

  message(sprintf("Assembling new document ..."))
  new_doc <- ""
  replacements <- list()
  for(block in blocks) {
    if(block$form == "inline") {
      new_doc <- paste(new_doc, paste(lines[block$start:block$end], collapse = "\n"), sep = "\n")
    } else {
      if(block$type == "sample-code") {
        if(is.null(ex_list[[block$ex]])) {
          message("A duplicate sample-code was found.")
        } else {
          # TODO ADD INFORMATION IF SECOND SAMPLE CODE WAS FOUND
          key = paste0("datacamp_light_exercise_", block$ex)
          new_doc <- paste(new_doc, "", key, "", sep = "\n")
          replacements <- c(replacements, list(list(patt = key, repl = ex_list[[block$ex]]$html)))
          ex_list[[block$ex]] <- NULL # remove from list so that in case of duplicate sample_code, it's not repeated
        }
      }
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
  for(r in replacements) {
    htmlfile <- gsub(sprintf("<p>%s</p>",r$patt), r$repl, htmlfile)
  }
  write(htmlfile, file = output_file)
  message(sprintf("Done! Your %s readable HTML file is available as %s.", project_alias, output_file))
}

