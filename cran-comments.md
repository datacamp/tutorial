## Test environments

* local OS X install, R 3.2.4
* ubuntu 12.04 (on travis-ci), R 3.2.4
* win-builder (release)

## R CMD check results

There were no ERRORs nor WARNINGs. There were 2 NOTEs:

* The package is MIT licensed and has a license template.
* File README.md cannot be checked without 'pandoc' being installed: pandoc is a dependency of this package

## Reverse dependencies

There are no packages depending on 'tutorial' yet.

## Patch

- Replaced hidden functions of the `knitr` and `rmarkdown` packages by exported functions.

## Other notes

'tutorial' registers a custom vignette engine on package load. The vignettes that are built feature JavaScript-powered interactive consoles. It all works locally, but this release is an experiment to check if it actually works on CRAN as well. My apologies if this causes issues.

https://cran.rstudio.com/web/checks/check_results_tutorial.html still lists some issues with some releases, because pandoc is not installed on those systems. I'd be more than happy to fix this if you can suggest a solution.


