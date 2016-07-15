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
#' @param height height in pixels that you want the resulting DataCamp Light
#'   frame to have.
#'
#' @importFrom knitr opts_knit knit_hooks opts_hooks
#' @export
go_interactive <- function(greedy = TRUE, height = 250) {

  stopifnot(is.logical(greedy))
  stopifnot(is.numeric(height))

  default_source_hook <- knitr::knit_hooks$get("source")
  default_document_hook <- knitr::knit_hooks$get("document")
  blocks <- NULL

  knitr::opts_hooks$set(eval = function(options) {
    if (tut_active(options, greedy)) {
      options$eval <- FALSE
    }
    options
  })

  knitr::knit_hooks$set(source = function(x, options) {
    if(tut_active(options, greedy)) {

      ex <- options[["ex"]]
      if (is.null(ex)) ex <- options$label

      if (!(ex %in% names(blocks))) {
        key <- sprintf("dc_light_exercise_%s", ex)
        blocks[[ex]] <<- list(height = NULL,
                              els = list(language = tolower(options$engine)),
                              ex = ex,
                              key = key)
      } else {
        # key is already in there
        key <- NULL
      }

      type <- options[["type"]]
      if (is.null(type)) type <- "sample-code"
      blocks[[ex]]$els[[type]] <<- paste(x, collapse = "\n")

      height <- options[["height"]]
      if (!is.null(height)) {
        blocks[[ex]]$height <<- height
      }

      return(key)
    } else {
      default_source_hook(x, options)
    }
  },
  document = function(x) {

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
        html <- render_exercise(block, default_height = height)
        x[x == sprintf("dc_light_exercise_%s", block$ex)] <- html
      }
      pre <- sprintf("<script src=\"https://cdn.datacamp.com/%s\"></script>\n", cdn_path)
      x <- c(pre, x)
    }

    return(default_document_hook(x))
  })
}

tut_active <- function(options, greedy) {
  if(greedy) {
    to_check <- is.null(options$tut) || isTRUE(options$tut)
  } else {
    to_check <- !is.null(options$tut) && isTRUE(options$tut)
  }
  to_check && options$echo && options$include
}
