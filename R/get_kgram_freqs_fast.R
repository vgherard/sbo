################################################################################
#' @rdname get_kgram_freqs
#' @export
#' @examples
#' \donttest{
#' # Obtain k-gram frequency table from corpus
#' ## Get k-gram frequencies, up to k = N = 3.
#' freqs <- get_kgram_freqs_fast(twitter_train, N = 3, dict = twitter_dict)
#' ## Print result
#' freqs
#' }
################################################################################

get_kgram_freqs_fast <- function(text, N, dict,
                                 erase = "[^.?!:;'\\w\\s]", lower_case = TRUE,
                                 EOS = ".?!:;"
                                 ){
        stopifnot(is.character(text))
        N %<>% as.integer
        stopifnot(length(N) == 1 & !is.na(N) & N >= 1L)
        .preprocess <- function(x) preprocess(x, erase, lower_case)

        if (!is.character(dict)) {
                dict %<>% as.integer
                if (is.na(dict) | length(dict) != 1)
                        stop("'dict' should be either a character vector or a
                             length one numeric or integer.")
                dict <- get_word_freqs(text, .preprocess = .preprocess,
                                       EOS = EOS)[1:dict] %>% names
        }

        counts <- lapply(get_kgram_freqs_fastC(text, N, dict, erase, lower_case,
                                               EOS),
                         function(x) {
                                 word_names <- paste0("w", (N + 2 - ncol(x)):N)
                                 colnames(x) <- c(word_names, "n")
                                 return(as_tibble(x))
                                 }
                         )

        return(structure(list(N = N, dict = dict, counts = counts,
                              .preprocess = .preprocess,
                              EOS = EOS),
                         class = "kgram_freqs"))
}
