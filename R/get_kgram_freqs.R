################################################################################
#' @rdname get_kgram_freqs
#' @export
#' @examples
#' \donttest{
#' # Obtain k-gram frequency table from corpus
#' ## Get k-gram frequencies, up to k = N = 3.
#' freqs <- get_kgram_freqs(twitter_train, N = 3, dict = twitter_dict)
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
                dict <- get_word_freqs(text, .preprocess = identity,
                                       EOS = EOS)[1:dict] %>% names
        }

        counts <- lapply(get_kgram_freqsC(text, N, dict),
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
