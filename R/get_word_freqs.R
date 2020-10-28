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
#' @param .preprocess a function for corpus preprocessing. Takes a character
#' vector as input and returns a character vector.
#' @param EOS a length one character vector listing all (single character)
#' end-of-sentence tokens.
#' @return A named integer containing word frequencies.
#' @examples
#' \donttest{
#' # Get word frequencies and extract dictionary of top 1000 words
#' words <- get_word_freqs(twitter_train)
#' words
#' dict <- names(words)[1:1000]
#' }
################################################################################

get_word_freqs <- function(text, .preprocess = preprocess, EOS = ".?!:;"){
        stopifnot(is.character(text))
        stopifnot(length(EOS) == 1 & is.character(EOS))
        stopifnot(is.function(.preprocess))
        text <- .preprocess(text)
        if (EOS != "") text <- tokenize_sentences(text, EOS = EOS)
        return( sort(get_word_freqsC(text), decreasing = TRUE) )
}
