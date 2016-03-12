parse_lines <- function(lns) {
  message(sprintf("Dividing document in %s code chunks and inline chunks ...", project_alias))
  begin_patt_ex <- "^[\t >]*```+\\s*\\{(r|python)+.*ex\\s*=\\s*[\"'](.+?)[\"'].*\\}\\s*$"
  begin_patt_type <- "^[\t >]*```+\\s*\\{(r|python)+.*type\\s*=\\s*[\"'](.+?)[\"'].*\\}\\s*$"
  end_patt <- "^[\t >]*```+\\s*$"
  starts <- which(grepl(begin_patt_ex, lns) & grepl(begin_patt_type, lns))
  ends <- which(grepl(end_patt, lns))


  if(1 %in% starts) stop(sprintf("Don't start your .Rmd file with a %s code chunk.", project_alias))
  current_state <- "inline"
  start <- 1
  blocks <- list()
  for(i in 2:length(lns)) {
    if(i %in% starts) {
      if(current_state == "inline") {
        blocks <- c(blocks, list(list(content = cpaste(lns[start:(i-1)]), form = "inline")))
      }
      lang = gsub(begin_patt_ex, "\\1", lns[i])
      ex = gsub(begin_patt_ex, "\\2", lns[i])
      type = gsub(begin_patt_type, "\\2", lns[i])
      block_id <- which(sapply(blocks, function(x) x$form == "code" && x$ex == ex))
      if(length(block_id) == 0) {
        blocks <- c(blocks, list(list(form = "code", ex = ex, lang = lang, els = list())))
        block_id <- length(blocks)
      }
      start <- i + 1
      current_state = "code"
    }

    if(i %in% ends) {
      if(current_state == "code") {
        blocks[[block_id]]$els[[type]] <- cpaste(lns[start:(i-1)])
        current_state <- ifelse((i + 1) %in% starts, "code", "inline")
        start <- i + 1
      }
    }
  }
  # If more inline stuff, also add it.
  if(start < length(lns)) {
    blocks <- c(blocks, list(list(content = cpaste(lns[start:length(lns)]), form = "inline")))
  }

  return(blocks)
}
