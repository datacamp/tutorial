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
  dict <- c(`pre-exercise-code` = "pre_exercise_code",
            `sample-code` = "sample",
            solution = "solution",
            sct = "sct",
            hint = "hint")
  names(els) <- dict[names(els)]
  encoded <- base64encode(charToRaw(toJSON(els)))
  pre <- "<script src=\"https://cdn.datacamp.com/datacamp-light-1.0.0.min.js\"></script>\n"
  patt <- "%s<div data-datacamp-exercise data-lang=\"%s\" data-height=\"%s\" data-encoded=\"true\">%s</div>"
  return(sprintf(patt, pre, block$lang, height, encoded))
}

get_height <- function(chunk_height, default_height) {

}
