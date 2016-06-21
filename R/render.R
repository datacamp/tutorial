#' @importFrom base64enc base64encode
#' @importFrom rjson toJSON
render_exercise <- function(els, lang, encoded) {
  els <- els[allowed_elements[allowed_elements %in% names(els)]]

  # if there's a hint, htmlify it
  if ("hint" %in% names(els)) {
    ind <- which(names(els) == "hint")
    els[[ind]] <- to_html(els[[ind]])
  }

  if (encoded) {
    # Translate pec and sample code for things to work in the encoded format
    dict <- c(`pre-exercise-code` = "pre_exercise_code",
              `sample-code` = "sample",
              solution = "solution",
              sct = "sct",
              hint = "hint")
    names(els) <- dict[names(els)]
    encoded <- base64encode(charToRaw(toJSON(els)))
    patt <- "<div data-datacamp-exercise data-lang=\"%s\" data-encoded=\"true\">%s</div>"
    return(sprintf(patt, lang, encoded))
  } else {
    html <- sprintf("<div data-datacamp-exercise data-lang=\"%s\">", lang)
    for (j in seq_along(els)) {
      el <- els[[j]]
      type <- names(els)[j]
      block <- ifelse(type == "hint",
                      "<div data-type=\"%s\">%s</div>",
                      "<code data-type=\"%s\">\n%s\n</code>")
      if (type == "hint") el <- to_html(el)
      html <- paste(html, sprintf(block, type, el), sep = "\n")
    }
    return(paste(html, "</div>", sep = "\n"))
  }
}
