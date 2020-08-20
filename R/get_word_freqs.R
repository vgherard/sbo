################################################################################
#' Word frequency tables
#'
#' Get word frequency tables from a training corpus.
#'
#' @author Valerio Gherardi
#' @md
#'
#' @export
#'
#' @param text a character vector. The training corpus from which to extract
#' word frequencies.
#' @param preproc a function for corpus preprocessing. Takes a character
#' vector as input and returns a character vector.
#' @return A tibble containing word frequencies.
#' @examples
#' # Get word frequencies and extract dictionary of top 1000 words
#' words <- get_word_freqs(twitter_train)
#' words
#' dict <- words$word[1:1000]
################################################################################

get_word_freqs <- function(text,
                           preproc = function(x)
                                   preprocess(x, split_sent = ".",
                                               omit_empty = TRUE)
                           ){
        stopifnot(is.character(text))
        text %>%
                preproc %>%
                stri_split_fixed(" ", omit_empty = TRUE) %>%
                unlist %>%
                tibble(word = .) %>%
                count(word, sort = TRUE)
}
