################################################################################
#' Word frequency tables
#'
#' Get word frequency tables from a training corpus.
#'
#' @author Valerio Gherardi
#' @md
#'
#' export
#'
#' @param text a character vector. The training corpus from which to extract
#' word frequencies.
#' @param .preprocess a function for corpus preprocessing. Takes a character
#' vector as input and returns a character vector.
#' @return A tibble containing word frequencies.
#' @examples
#' \dontrun{
#' # Get word frequencies and extract dictionary of top 1000 words
#' words <- get_word_freqs(twitter_train)
#' words
#' dict <- words$word[1:1000]
#' }
################################################################################

get_word_freqs <- function(text, .preprocess = preprocess){
        stopifnot(is.character(text))
        stopifnot(is.function(.preprocess))
        text <- .preprocess(text)
        return( get_word_freqsC(text) %>% sort(decreasing = TRUE) )
}
