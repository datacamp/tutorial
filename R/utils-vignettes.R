tutweave <- function(file, quiet, ...) {
  render(file, open = FALSE, quiet = quiet, ...)
}

register_vignette_engines <- function(pkg) {
  vig_engine('tutorial', tutweave, '[.][Rr](md|markdown)$')
}

#' @importFrom knitr knit_filter
vig_engine <- function(..., tangle = knitr:::vtangle) {
  knitr:::vig_engine0(..., tangle = tangle, package = "tutorial", aspell = list(
    filter = knit_filter
  ))
}

