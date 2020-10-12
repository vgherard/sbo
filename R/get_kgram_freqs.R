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
#' @param dict either a character vector, or a length one integer/numeric.
#' The language model fixed dictionary (see details), sorted by word frequency.
#' If numeric, the dictionary is obtained from the training corpus using
#' the \code{dict} most frequent words.
#' @param N a length one integer. The maximum order of \eqn{latex}{k}-grams
#' for which frequencies are sought.
#' @param preproc a function for corpus preprocessing and sentence tokenization.
#' Takes a character vector as input and returns a character vector, each
#' element of it corresponding to a separate sentence.
#' @return A \code{kgram_freqs} object, containing the \eqn{latex}{k}-gram
#' frequency tables for \eqn{latex}{k = 1, 2, ..., N}.
#' @details This function extracts all k-gram frequency tables from a text
#' corpus up to a specified \eqn{latex}{k}-gram order \eqn{latex}{N}. These are
#' the building blocks to train any \eqn{latex}{N}-gram model.
#'
#' \code{get_kgram_freqs} employs a fixed (user specified) dictionary; any
#' out-of-vocabulary word gets effectively replaced by an "unknown word" token.
#'
#' The return value is a "\code{kgram_freqs}" object, i.e. a list containing:
#'
#' - The highest order of \eqn{latex}{N}-grams, \eqn{latex}{N}.
#' - The reference dictionary, sorted by word frequency. This can be obtained
#' using \code{\link[sbo]{get_word_freqs}}.
#' - A list of n tibbles, storing frequency counts for each
#' \eqn{latex}{k}-gram observed in the training corpus, for
#' \eqn{latex}{k = 1, 2, ..., N}. In these tibbles, words are represented by
#' integer numbers corresponding to their position in the
#' reference dictionary. The special codes \code{0},
#' \code{length(dictionary)+1} and \code{length(dictionary)+2}
#' correspond to the "Begin-Of-Sentence", "End-Of-Sentence"
#' and "Unknown word" tokens, respectively.
#'
#' The \code{preproc} argument allows the user to employ a custom corpus
#' preprocessing function (the default leverages on
#' \code{\link[sbo]{preprocess}}), which should additionally perform
#' tokenization at the sentence level. It is important to note that each
#' element of the vector \code{preproc(text)} gets interpreted as a separate
#' sentence in the \eqn{latex}{k}-gram tokenization algorithm.
#' @seealso \code{\link[sbo]{get_word_freqs}}
#' @examples
#' \dontrun{
#' # Obtain k-gram frequency table from corpus
#' ## Get k-gram frequencies, up to k = N = 3.
#' freqs <- get_kgram_freqs(twitter_train, twitter_dict, N = 3)
#' ## Print result
#' freqs
#' }
################################################################################

get_kgram_freqs <- function(text, N, dict, .preprocess = preprocess,
                            EOS = ".?!:;"
                            ){
        stopifnot(is.character(text))
        N %<>% as.integer
        stopifnot(length(N) == 1 & !is.na(N) & N >= 1L)
        stopifnot(is.function(.preprocess))

        text <- .preprocess(text)
        if (EOS != "") text <- tokenize_sentences(text, EOS = EOS)
        if (!is.character(dict)) {
                dict %<>% as.integer
                if (is.na(dict) | length(dict) != 1)
                        stop("'dict' should be either a character vector or a
                             length one numeric or integer.")
                dict <- get_word_freqs(text, .preprocess = identity)[1:dict] %>%
                        names
        }

        counts <- lapply(get_kgram_freqsC(text, dict, N),
                         function(x) {
                                 word_names <- paste0("w", (N + 2 - ncol(x)):N)
                                 colnames(x) <- c(word_names, "n")
                                 return(as_tibble(x))
                                 }
                         )

        return(structure(list(N = N, dict = dict, counts = counts,
                              .preprocess = .preprocess, EOS = EOS),
                         class = "kgram_freqs"))
}
