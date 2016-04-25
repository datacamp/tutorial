## Test environments

* local OS X install, R 3.2.4
* ubuntu 12.04 (on travis-ci), R 3.2.4
* win-builder (release)

## R CMD check results

There were no ERRORs nor WARNINGs. There were 3 NOTEs:

* The package is MIT licensed and has a license template.
* File README.md cannot be checked without 'pandoc' being installed: pandoc is a dependency of this package
* Unexported objects imported by ':::' calls: I depend on some unexported 'knitr' and 'rmarkdown' functions. Copying these functions and all the internal functions they depend on to the tutorial package itself would be huge code duplication.

## Reverse dependencies

There are no packages depending on 'tutorial' yet.

## Other notes

'tutorial' registers a custom vignette engine on package load. The vignettes that are built feature JavaScript-powered interactive consoles. It all works locally, but this release is an experiment to check if it actually works on CRAN as well. My apologies if this causes issues.


