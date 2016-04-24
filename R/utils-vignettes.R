tutweave <- function(file, ...) {
  render(file, open = FALSE, ...)
}

register_vignette_engines <- function(pkg) {
  vig_engine('tutorial', tutweave, '[.][Rr](md|markdown)$')
}

vig_engine <- function(..., tangle = knitr:::vtangle) {
  knitr:::vig_engine0(..., tangle = tangle, package = "rmarkdown", aspell = list(
    filter = knitr:::knit_filter
  ))
}

