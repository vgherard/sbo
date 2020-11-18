
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sbo

<!-- badges: start -->

[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/vgherard/sbo?branch=master&svg=true)](https://ci.appveyor.com/project/vgherard/sbo)
[![CircleCI build
status](https://circleci.com/gh/vgherard/sbo.svg?style=svg)](https://circleci.com/gh/vgherard/sbo)
[![Codecov test
coverage](https://codecov.io/gh/vgherard/sbo/branch/master/graph/badge.svg)](https://codecov.io/gh/vgherard/sbo?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/sbo)](https://CRAN.R-project.org/package=sbo)
[![CRAN
downloads](http://cranlogs.r-pkg.org/badges/grand-total/sbo)](https://CRAN.R-project.org/package=sbo)
<!-- badges: end -->

`sbo` provides utilities for building and evaluating next-word
prediction functions based on [Stupid
Back-off](https://www.aclweb.org/anthology/D07-1090.pdf) [N-gram
models](https://en.wikipedia.org/wiki/N-gram) in R. It includes
functions such as:

  - `kgram_freqs()`: Extract \(k\)-gram frequency tables from a
    text corpus
  - `train_predictor()`: Train a next-word predictor via Stupid
    Back-off.
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

This example shows the prototypical workflow for building a
text-predictor with `sbo`:

``` r
library(sbo)
## Train a next-word prediction function based on 3-gram Stupid Back-off. 
train <- sbo::twitter_train # 70k tweets, example dataset from sbo
word_freqs <- get_word_freqs(train) # word frequencies stored as named integer
dict <- names(word_freqs)[1:1000] # Build rank-sorted dictionary
freqs <- kgram_freqs(train, N = 3, dict) # Get k-gram frequencies (up to 3-grams)
p <- train_predictor(freqs, L = 3) # Train next-word predictor, store top L = 3 predictions
```

The object `p` now stores the next-word prediction tables, which can be
used to generate predictive text as follows:

``` r
predict(p, "i love") # a character vector
#> [1] "you" "it"  "the"
predict(p, "you love") # another character vector
#> [1] "me"    "<EOS>" "it"
predict(p, c("i love", "you love")) # a character matrix
#>      [,1]  [,2]    [,3] 
#> [1,] "you" "it"    "the"
#> [2,] "me"  "<EOS>" "it"
```

## Help

For help, see the `sbo` [website](https://vgherard.github.io/sbo/)
