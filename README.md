
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sbo

<!-- badges: start -->

<!-- badges: end -->

`sbo` provides utilities for building and evaluating next-word
prediction functions based on [Stupid
Back-off](https://www.aclweb.org/anthology/D07-1090.pdf) [N-gram
models](https://en.wikipedia.org/wiki/N-gram) in R. It includes
functions such as:

  - `get_kgram_freqs()`: Extract \(k\)-gram frequency tables from a text
    corpus
  - `build_sbo_preds()`: Build next-word prediction tables from Stupid
    Back-off \(N\)-gram model. Allows compact and efficient
    storage/retrieval of a text prediction function.
  - `eval_sbo_preds()`: Test model predictions against an independent
    corpus.

## Installation

You can install `sbo` from [GitHub](https://github.com/vgherard/sbo):

``` r
# install.packages("devtools")
devtools::install_github("vgherard/sbo")
```

The latter command will not build vignettes. If you want to build
vignettes also, do `devtools::install_github("vgherard/sbo",
build_vignettes = TRUE)` instead.

## Example

This example shows the prototypical workflow for building a
text-predictor with `sbo`:

``` r
library(sbo)
## Train a next-word prediction function based on 3-gram Stupid Back-off. 
train <- sbo::twitter_train # 100k tweets, example dataset from sbo
dict <- get_word_freqs(train) %>% names %>% .[1:1000] # Build rank-sorted dictionary
freqs <- get_kgram_freqs(train, N = 3, dict) # Get k-gram frequencies (up to 3-grams)
preds <- build_sbo_preds(freqs) # Build prediction tables
```

The `preds` object now stores the next-word prediction tables, which can
be used to generate predictive text as follows:

``` r
predict(preds, "i love") # a character vector
#> [1] "you" "it"  "my"
predict(preds, c("Colorless green ideas sleep", "See you")) # a char matrix
#>      [,1]    [,2]    [,3] 
#> [1,] "<EOS>" "in"    "and"
#> [2,] "there" "<EOS>" "at"
```

## Help

For help, see the `sbo` [website](https://vgherard.github.io/sbo/)
