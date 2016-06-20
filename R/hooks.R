
#' @export
go_interactive <- function() {
  tutorial$clear()

  knitr::opts_hooks$set(eval = function(options) {
    if (tut_active(options)) {
      options$eval <- FALSE
    } else {
      options$eval <- TRUE
    }
    options
  })

  knitr::knit_hooks$set(source = extract_elements,
                        document = replace_elements)
}

tut_active <- function(options) {
  is.null(options$tut) || isTRUE(options$tut)
}

extract_elements <- function(x, options) {
  if(tut_active(options)) {

    blocks <- tutorial$get("blocks")
    lang <- tolower(options$engine)

    ex <- options$title
    if(is.null(ex)) ex <- options$label

    type <- options$type
    if(is.null(type)) type <- "sample-code"

    if (!(ex %in% names(blocks))) {
      key <- sprintf("dc_light_exercise_%s", ex)
      blocks[[ex]] <- list(lang = lang,
                           els = list(),
                           ex = ex,
                           key = key)
    } else {
      key <- NULL
    }

    blocks[[ex]]$els[[type]] <- paste(x, collapse = "\n")
    tutorial$set(blocks = blocks)

    # return(paste(c("```", capture.output(str(blocks)), "```"), collapse = "\n"))
    return(key)
  } else {
    # x <- c(hilight_source(x, "html", options)
    x <- paste(x, "", collapse = "\n")
    sprintf("<div class=\"source\"><pre class=\"knitr %s\">%s</pre></div>\n", tolower(options$engine), x)
  }
}

replace_elements <- function(x) {

  blocks <- tutorial$get("blocks")

  for (block in blocks) {
    if (!all(required_elements %in% names(block$els))) {
      stop(sprintf("%s does not contain all required elements. You need %s",
                   block$ex, collapse(required_elements)))
    }
    if (!all(names(block$els) %in% allowed_elements)) {
      stop(sprintf("%s contains elements that are not understood by %s.",
                   block$ex, project_alias))
    }
    html <- build_exercise_html(block$lang, block$els, TRUE)
    x[x == sprintf("dc_light_exercise_%s", block$ex)] <- html
  }

  paste(c("<script src=\"https://cdn.datacamp.com/datacamp-light-1.0.0.min.js\"></script>\n", x, "```", capture.output(str(blocks)), "```"), collapse = "\n")

}
