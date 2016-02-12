# tutorial (beta)

[![Build Status](https://api.travis-ci.org/datacamp/tutorial.svg?branch=master)](https://travis-ci.org/datacamp/tutorial)
[![codecov.io](https://codecov.io/github/datacamp/tutorial/coverage.svg?branch=master)](https://codecov.io/github/datacamp/tutorial?branch=master)

Easily create interactive tutorials powered by [DataCamp Light](https://www.github.com/datacamp/datacamp-light) for the web based on R Markdown files.

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

## How it works

This group of code chunks:

    ```{r ex="create_a", type="pre-exercise-code"}
    # This code is available in the workspace when the session initializes
    b <- 5
    ```
    
    ```{r, ex="create_a", type="sample-code"}
    # Create a variable a, equal to 5
    
    
    # Print out a
    
    ```
    
    ```{r, ex="create_a", type="solution"}
    # Create a variable a, equal to 5
    a <- 5
    
    # Print out a
    a
    ```
    
    ```{r, ex="create_a", type="sct"}
    test_object("a")
    test_output_contains("a", incorrect_msg = "Make sure to print `a`")
    success_msg("Great!")
    ```
    
    ```{r, ex="create_a", type="hint"}
    Here is a hint: use `<-` for assignment
    ```

Converts to the following DataCamp Light exercise:

![resulting_exercise](https://s3.amazonaws.com/assets.datacamp.com/img/github/content-engineering-repos/tutorial_exercise.png)

These `ex` and `type` chunk options are specific to the `tutorial` package and are not understood by R Markdown ([`knitr`](https://github.com/yihui/knitr)). To ensure backwards compatibility with systems that don't feature the `tutorial` package, you can include `eval = FALSE, include = FALSE` at the beginning of all code chunks.

## Other Documentation

- [DataCamp Light JS library](https://www.github.com/datacamp/datacamp-light)
- [Course creation for DataCamp](https://docs.datacamp.com/teach)

For more details, questions and suggestions, you can contact <b>support@datacamp.com</b>.
