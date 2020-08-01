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
#' @return A tibble containing word frequencies.
#' @examples
#' # Get word frequencies and extract dictionary of top 1000 words
#' words <- get_word_freqs(twitter_train)
#' words
#' dict <- words$word[1:1000]
################################################################################

get_word_freqs <- function(text){
        stopifnot(class(text) == "character")
        text %>%
                preprocess(split_sent = ".", omit_empty = TRUE) %>%
                stri_split_fixed(" ", omit_empty = TRUE) %>%
                unlist %>%
                tibble(word = .) %>%
                count(word, sort = TRUE)
}
