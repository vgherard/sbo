################################################################################
#' @rdname get_sbo_kgramfreqs
#' @export
#' @examples
#' \donttest{
#' # Obtain k-gram frequency table from corpus
#' ## Get k-gram frequencies, up to k = N = 3.
#' freqs <- get_sbo_kgramfreqs(twitter_train, N = 3, dict = twitter_dict)
#' ## Print result
#' freqs
#' }
################################################################################

get_sbo_kgramfreqs <- function(text, N, dict, .preprocess = preprocess,
                            EOS = ".?!:;"
                            ){
        stopifnot(is.character(text))
        N <- as.integer(N)
        stopifnot(length(N) == 1 & !is.na(N) & N >= 1L)
        stopifnot(is.function(.preprocess))

        text <- .preprocess(text)
        if (EOS != "") text <- tokenize_sentences(text, EOS = EOS)
        if (!is.character(dict)) {
                if (!is.numeric(dict) | length(dict) != 1)
                        stop("'dict' should be either a character vector or a
                             length one numeric.")
                if (dict < 0) stop("Dictionary length should be >= 0!")
                word_freqs <- get_word_freqs(text, 
                                             .preprocess = identity, 
                                             EOS = EOS)
                V <- min(length(word_freqs), dict)
                dict <- names(word_freqs)[seq_len(V)]
        }

        counts <- lapply(get_sbo_kgramfreqsC(text, N, dict),
                         function(x) {
                                 word_names <- paste0("w", (N + 2 - ncol(x)):N)
                                 colnames(x) <- c(word_names, "n")
                                 return(as_tibble(x))
                                 }
                         )

        structure(counts,
                  N = N, dict = dict, 
                  .preprocess = utils::removeSource(.preprocess), EOS = EOS,
                  class = "sbo_kgramfreqs"
                  ) # return
}
