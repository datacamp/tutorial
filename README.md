# tutorial

[![Build Status](https://api.travis-ci.org/datacamp/tutorial.svg?branch=master)](https://travis-ci.org/datacamp/tutorial)
[![codecov.io](https://codecov.io/github/datacamp/tutorial/coverage.svg?branch=master)](https://codecov.io/github/datacamp/tutorial?branch=master)

Create interactive online tutorials powered by [DataCamp Light](https://www.github.com/datacamp/datacamp-light) from R Markdown files. You can create both R and Python exercises with the `tutorial` package.

## Installing the package

```R
if(!require(devtools))
  install.packages("devtools")
library(devtools)
install_github("datacamp/tutorial")
```

## Getting started

```R
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

![start](https://s3.amazonaws.com/assets.datacamp.com/img/github/content-engineering-repos/tutorial1_start.png)

If you make an incorrect submission, you get automated feedback (through the SCT, short for Submission Correctness Test):

![incorrect](https://s3.amazonaws.com/assets.datacamp.com/img/github/content-engineering-repos/tutorial2_incorrect.png)

You can ask for a hint:

![hint](https://s3.amazonaws.com/assets.datacamp.com/img/github/content-engineering-repos/tutorial3_hint.png)

Ultimately, you can ask for the solution:

![solution](https://s3.amazonaws.com/assets.datacamp.com/img/github/content-engineering-repos/tutorial4_solution.png)

If you submit this code, you will get a success message:

![success](https://s3.amazonaws.com/assets.datacamp.com/img/github/content-engineering-repos/tutorial5_correct.png)

## Other Documentation

- [R Markdown](http://rmarkdown.rstudio.com/) and [knitr](http://yihui.name/knitr/) for dynamic documents with R. To ensure backwards compatibility with systems that don't feature the `tutorial` package, you can include `eval = FALSE, include = FALSE` at the beginning of all code chunks. In that case, R Markdown files can be rendered to HTML files without problems; the interactive exercises simply will not be included.
- [DataCamp Light JS library](https://www.github.com/datacamp/datacamp-light)
- [Course creation for DataCamp](https://www.datacamp.com/teach/documentation)

For more details, questions and suggestions, you can contact <b>content-engineering@datacamp.com</b>.
