################################################################################
#' \eqn{latex}{k}-gram frequency tables
#'
#' Get \eqn{latex}{k}-gram frequency tables from a training corpus.
#'
#' @author Valerio Gherardi
#' @md
#'
#' @export
#'
#' @param text a character vector. The training corpus from which to extract
#' k-gram frequencies.
#' @param dict a character vector. The language model fixed dictionary (see
#' details), sorted by word frequency.
#' @param n a length one integer. The maximum order of \eqn{latex}{k}-grams
#' for which frequencies are sought.
#' @return A \code{kgram_freqs} object, containing the \eqn{latex}{k}-gram
#' frequency tables for \eqn{latex}{k = 1, 2, ..., n}.
#' @details This function extracts all k-gram frequency tables from a text
#' corpus up to a specified \eqn{latex}{k}-gram order \eqn{latex}{n}. These are
#' the building blocks to train any \eqn{latex}{n}-gram model.
#'
#' \code{get_kgram_freqs} employs a fixed (user specified) dictionary; any
#' out-of-vocabulary word gets effectively replaced by an "unknown word" token.
#'
#' The return value is a "\code{kgram_freqs}" object, i.e. a list containing:
#'
#' - The highest order of \eqn{latex}{k}-grams, \eqn{latex}{n}.
#' - The reference dictionary, sorted by word frequency. This can be obtained
#' using \code{\link[sbo]{get_word_freqs}}.
#' - A list of n tibbles, storing frequency counts for each
#' \eqn{latex}{k}-gram observed in the training corpus, for
#' \eqn{latex}{k = 1, 2, ..., n}. In these tibbles, words are represented by
#' integer numbers corresponding to their position in the
#' reference dictionary. The special codes \code{0},
#' \code{length(dictionary)+1} and \code{length(dictionary)+2}
#' correspond to the "Begin-Of-Sentence", "End-Of-Sentence"
#' and "Unknown word" tokens, respectively.
#' @seealso \code{\link[sbo]{get_word_freqs}}
#' @examples
#' # Obtain k-gram frequency table from corpus
#' ## Get k-gram frequencies, up to k = n = 3.
#' freqs <- get_kgram_freqs(twitter_train, twitter_dict, n = 3)
#' ## Print result
#' freqs
################################################################################

get_kgram_freqs <- function(text, dict, n){
        stopifnot(is.character(text), is.character(dict))
        stopifnot(length((n %<>% as.integer))==1)
        if(is.na(n) | n < 1L)
                stop("n_max could not be coerced to a positive integer")
        stopifnot(is.integer(n), length(n) == 1)
        wrap <- c(paste0(rep("_BOS_", n-1), collapse = " "), "_EOS_")
        text %<>% preprocess(split_sent = ".", wrap = wrap) %>% get_words(dict)
        # Get k-gram counts
        counts <- lapply(1:n, function(k)
                        text %>%
                                # construct k column k-gram matrix
                                sliding_matrix(ncol = k) %>%
                                # drop k-grams ending by "BOS"
                                subset(.[, k] != 0, drop = F) %>%
                                `colnames<-`(paste0("w",(n-k+1):n)) %>%
                                as_tibble %>%
                                count(across(everything()), sort = TRUE)
                       )
        structure( list(n = n, dict = dict, counts = counts),
                   class = "kgram_freqs" )
}
