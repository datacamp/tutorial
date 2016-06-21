#' Set up your R Markdown document to use DataCamp light
#'
#' Enable hooks and parsing utilities so that special code chunks where the
#' \code{ex} and \code{type} options are specified, are converted into
#' interactive exercises on the resulting HTML page. Use
#' \code{\link{build_example}} to generate an example document. Simply knitting
#' this document will generate a document with DataCamp Light powered code
#' chunks.
#'
#' With the \code{greedy} argument, you can control which elements of your R
#' Markdown document are converted into DataCamp Light chunks. By default
#' \code{greedy} is \code{TRUE}, leading to all R code chunks to be converted to
#' interactive frames. Only chunks for which you specify the option \code{tut =
#' FALSE} are not converted. If `greedy` is  \code{FALSE}, only chunks for which
#' you specify \code{tut = TRUE} are converted.
#'
#' @param greedy whether or not to 'greedily' convert code chunks into DataCamp
#'   Light frames.
#'
#' @importFrom knitr opts_knit knit_hooks opts_hooks
#' @export
go_interactive <- function(greedy = TRUE) {
  tutorial$clear()
  tutorial$set(greedy = greedy)

  # out_type <- knitr::opts_knit$get("out.format")
  # if (!length(intersect(out_type, c("markdown", "html"))))
  #   stop("DataCamp Light is for HTML only.")

  knitr::opts_hooks$set(eval = function(options) {
    if (tut_active(options)) {
      options$eval <- FALSE
      options$echo <- TRUE
    }
    options
  })

  tutorial$set(default_source_hook = knitr::knit_hooks$get("source"))
  knitr::knit_hooks$set(source = extract_elements,
                        document = replace_elements)
}

tut_active <- function(options) {
  if(tutorial$get("greedy")) {
    is.null(options$tut) || isTRUE(options$tut)
  } else {
    !is.null(options$tut) && isTRUE(options$tut)
  }
}

extract_elements <- function(x, options) {
  if(tut_active(options)) {

    blocks <- tutorial$get("blocks")
    lang <- tolower(options$engine)

    ex <- options[["ex"]]
    if(is.null(ex)) ex <- options$label

    type <- options[["type"]]
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
    tutorial$get("default_source_hook")(x, options)
  }
}

replace_elements <- function(x) {

  blocks <- tutorial$get("blocks")

  if (length(blocks) > 0) {
    for (block in blocks) {
      if (!all(required_elements %in% names(block$els))) {
        stop(sprintf("%s does not contain all required elements. You need %s",
                     block$ex, collapse(required_elements)))
      }
      if (!all(names(block$els) %in% allowed_elements)) {
        stop(sprintf("%s contains elements that are not understood by %s.",
                     block$ex, project_alias))
      }
      html <- render_exercise(els = block$els,
                              lang = block$lang,
                              encoded = TRUE)
      x[x == sprintf("dc_light_exercise_%s", block$ex)] <- html
    }
    x <- c("<script src=\"https://cdn.datacamp.com/datacamp-light-1.0.0.min.js\"></script>\n", x)
  }

  return(x)
}
