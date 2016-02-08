# tutorial (beta)

[![Build Status](https://api.travis-ci.org/datacamp/tutorial.svg?branch=master)](https://travis-ci.org/datacamp/tutorial)
[![codecov.io](https://codecov.io/github/datacamp/tutorial/coverage.svg?branch=master)](https://codecov.io/github/datacamp/tutorial?branch=master)

Easily create interactive tutorials for the web based on R Markdown files.

## Installing the package

```
if(!require(devtools))
  install.packages("devtools")
library(devtools)
install_github("datacamp/tutorial")
```

## Getting started

```
library(tutorial)
build_example()
render("example.Rmd")
```

## Other Documentation

- DataCamp Light JS library: www.github.com/datacamp/datacamp-light
- Course creation for DataCamp: docs.datacamp.com/teach

For more details, questions and suggestions, you can contact <b>support@datacamp.com</b>.

<p align="center">
<img src="https://s3.amazonaws.com/assets.datacamp.com/img/logo/logo_blue_full.svg" width="150manag">
</p>
