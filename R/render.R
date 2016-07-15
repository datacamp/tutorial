#' @importFrom base64enc base64encode
#' @importFrom rjson toJSON
render_exercise <- function(block, default_height) {

  els <- block$els[allowed_elements[allowed_elements %in% names(block$els)]]

  # if there's a hint, htmlify it
  if ("hint" %in% names(els)) {
    ind <- which(names(els) == "hint")
    els[[ind]] <- to_html(els[[ind]])
  }

  # determine block height
  height <- block$height
  if (is.null(block$height)) {
    height <- default_height
  }

  # Translate pec and sample code for things to work in the encoded format
  els <- rename(els, "pre-exercise-code", "pre_exercise_code")
  els <- rename(els, "sample-code", "sample")

  encoded <- base64encode(charToRaw(toJSON(els)))
  patt <- "<div data-datacamp-exercise data-height=\"%s\" data-encoded=\"true\">%s</div>"
  return(sprintf(patt, height, encoded))
}

rename <- function(named_vec, from, to) {
  x <- which(names(named_vec) == from)
  if (length(x) > 0) {
    names(named_vec)[x] <- to
  }
  return(named_vec)
}
