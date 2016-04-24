![banner](https://s3.amazonaws.com/assets.datacamp.com/img/github/content-engineering-repos/tutorial_banner_v2.png)

[![Build Status](https://api.travis-ci.org/datacamp/tutorial.svg?branch=master)](https://travis-ci.org/datacamp/tutorial)
[![codecov.io](https://codecov.io/github/datacamp/tutorial/coverage.svg?branch=master)](https://codecov.io/github/datacamp/tutorial?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/tutorial)](http://cran.r-project.org/package=tutorial)

Wrapper around `knitr` to convert your static code chunks into a R/Python editor where people can experiment. Powered by [DataCamp Light](https://www.github.com/datacamp/datacamp-light).

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

R vignettes, blog posts and teaching material are typically standard web pages generated with R markdown. DataCamp has developed a framework to make this static content interactive: R code chunks are converted into an R-session backed editor so readers can experiment.

With `tutorial::render()`, you turn an R Markdown document like this:   

    ---
    title: "Example Document"
    author: "Your name here"
    output: html_document
    ---

    If you specify the `ex` and `type` properties, `tutorial` knows what to do.

    ```{r, ex="play_around", type="sample-code"}
    a <- 2
    b <- 3

    a + b
    ```

Into an HTML file that features an in-browser R editor with a session attached to it, where you can experiment.

![html_file](https://s3.amazonaws.com/assets.datacamp.com/img/github/content-engineering-repos/tutorial_html_file.png)

![html_file_run](https://s3.amazonaws.com/assets.datacamp.com/img/github/content-engineering-repos/tutorial_html_file_run.png)

You can also embed coding challenges into your webpages. This group of code chunks:

    ```{r ex="create_a", type="pre-exercise-code"}
    # This code is available in the workspace when the session initializes
    b <- 5
    ```
    
    ```{r ex="create_a", type="sample-code"}
    # Create a variable a, equal to 5
    
    
    # Print out a
    
    ```
    
    ```{r ex="create_a", type="solution"}
    # Create a variable a, equal to 5
    a <- 5
    
    # Print out a
    a
    ```
    
    ```{r ex="create_a", type="sct"}
    test_object("a")
    test_output_contains("a", incorrect_msg = "Make sure to print `a`")
    success_msg("Great!")
    ```
    
    ```{r ex="create_a", type="hint"}
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
- [Course creation for DataCamp](https://www.datacamp.com/teach/documentation). The documentation includes information on how to get started with course creation, what the different components of an exercise are, how you can write Submission Correctness Tests (SCTs) etc.

For more details, questions and suggestions, you can contact <b>content-engineering@datacamp.com</b>.
