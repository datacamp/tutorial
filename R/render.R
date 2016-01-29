#' Create DataCamp Light readable HTML file
#'
#' Currently only supports passing an input file, no other input methods possible.
#'
#' @export
render <- function(input, ...) {

  lines <- readLines(input)

  begin_patt <- "^[\t >]*```+\\s*\\{[.]?[a-zA-Z]+.*ex\\s*=(.*?),\\s*type\\s*=(.*?)\\}\\s*$"
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

  chunk_lines <- matrix(c(dl_starts, dl_ends), ncol = 2)

  # Convert code blocks to <code><code> stuff
  ex_list = list()
  for(i in 1:nrow(chunk_lines)) {
    cb <- lines[chunk_lines[i,1]: chunk_lines[i,2]]
    ex = gsub(begin_patt, "\\1", cb[1])
    type = gsub(begin_patt, "\\2", cb[1])
    if(is.null(ex_list[[ex]])) {
      ex_list[[ex]] = list()
    }
    ex_list[[ex]][[type]] = list()
    ex_list[[ex]][[type]][["content"]] = paste(cb[2:(length(cb)-1)], collapse = "\n")
    ex_list[[ex]][[type]][["start"]] = chunk_lines[i,1]
    ex_list[[ex]][[type]][["end"]] = chunk_lines[i,2]
  }

  # Write into lines again


  # Build file again


  args = list(...)
  args$output_format = "html_document"
  args$input =
  do.call(rmarkdown::render, args = args)
}

render_part <- function(x) UseMethod("render_part")

render_part.default <- function(x) { x$input }

render_part.block <- function(x) {
  # If no DataCamp Light keywords, return source
  if(is.null(x$params$type) || is.null(x$params$ex)) return(x$input)


}
