
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sbo

<!-- badges: start -->

[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/vgherard/sbo?branch=master&svg=true)](https://ci.appveyor.com/project/vgherard/sbo)
[![CircleCI build
status](https://circleci.com/gh/vgherard/sbo.svg?style=svg)](https://circleci.com/gh/vgherard/sbo)
[![GitHub Actions build
status](https://github.com/vgherard/sbo/workflows/R-CMD-check/badge.svg)](https://github.com/vgherard/sbo/actions)
[![Codecov test
coverage](https://codecov.io/gh/vgherard/sbo/branch/master/graph/badge.svg)](https://codecov.io/gh/vgherard/sbo?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/sbo)](https://CRAN.R-project.org/package=sbo)
[![CRAN
downloads](http://cranlogs.r-pkg.org/badges/grand-total/sbo)](https://CRAN.R-project.org/package=sbo)
<!-- badges: end -->

`sbo` provides utilities for building and evaluating text predictors
based on [Stupid
Back-off](https://www.aclweb.org/anthology/D07-1090.pdf) N-gram models
in R. It includes functions such as:

  - `kgram_freqs()`: Extract \(k\)-gram frequency tables from a text
    corpus
  - `sbo_predictor()`: Train a next-word predictor via Stupid Back-off.
  - `eval_sbo_predictor()`: Test text predictions against an independent
    corpus.

## Installation

### Released version

You can install the latest release of `sbo` from CRAN:

``` r
install.packages("sbo")
```

### Development version:

You can install the development version of `sbo` from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("vgherard/sbo")
```

## Example

This example shows how to build a text predictor with `sbo`:

``` r
library(sbo)
p <- sbo_predictor(sbo::twitter_train, # 50k tweets, example dataset
                   N = 3, # Train a 3-gram model
                   dict = sbo::twitter_dict, # Top 1k words appearing in corpus
                   .preprocess = sbo::preprocess, # Preprocessing transformation
                   EOS = ".?!:;" # End-Of-Sentence characters
                   )
```

The object `p` can now be used to generate predictive text as follows:

``` r
predict(p, "i love") # a character vector
#> [1] "you" "it"  "my"
predict(p, "you love") # another character vector
#> [1] "<EOS>" "me"    "the"
predict(p, 
        c("i love", "you love", "she loves", "we love", "you love", "they love")
        ) # a character matrix
#>      [,1]    [,2]  [,3] 
#> [1,] "you"   "it"  "my" 
#> [2,] "<EOS>" "me"  "the"
#> [3,] "you"   "my"  "me" 
#> [4,] "you"   "our" "it" 
#> [5,] "<EOS>" "me"  "the"
#> [6,] "to"    "you" "and"
```

## Help

For help, see the `sbo` [website](https://vgherard.github.io/sbo/).
