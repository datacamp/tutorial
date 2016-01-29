get_code_chunks <- function(lines) {

  # Fix markdown format
  old.format <- knitr:::opts_knit$get()
  knitr:::opts_knit$set(out.format = "markdown")

  # Fix pattern business
  apat = knitr::all_patterns; opat = knit_patterns$get()
  on.exit({
    knit_patterns$restore(opat)
    knitr:::chunk_counter(reset = TRUE)
    knitr:::knit_code$restore(list())
    knitr:::opts_knit$set(old.format)
  })
  pat_md()

  content = knitr:::split_file(lines = lines)
  code_chunks <- knitr:::knit_code$get()

  for(i in seq_along(content)) {
    if(class(content[[i]]) == "block") {
      label <- content[[i]]$params$label
      content[[i]]$input <- paste(code_chunks[[label]],collapse = "\n")
    }
  }

  return(content)
}
