parse_lines <- function(lines) {
  message(sprintf("Dividing document in %s code chunks and inline chunks ...", project_alias))
  begin_patt <- "^[\t >]*```+\\s*\\{[.]?[a-zA-Z]+.*ex\\s*=(.*?)\\s*,\\s*type\\s*=(.*?)\\}\\s*$"
  end_patt <- "^[\t >]*```+\\s*$"
  starts <- which(grepl(begin_patt, lines))
  ends <- which(grepl(end_patt, lines))


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
}
