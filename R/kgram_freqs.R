################################################################################
#' @rdname kgram_freqs
#' @export
#' @examples
#' \donttest{
#' # Obtain k-gram frequency table from corpus
#' ## Get k-gram frequencies, for k <= N = 3.
#' ## The dictionary is built on the fly, using the most frequent 1000 words.
#' freqs <- kgram_freqs(corpus = twitter_train, N = 3, dict = max_size ~ 1000,
#'                      .preprocess = preprocess, EOS = ".?!:;")
#' freqs
#' ## Using a predefined dictionary
#' freqs <- kgram_freqs_fast(twitter_train, N = 3, dict = twitter_dict,
#'                           erase = "[^.?!:;'\\w\\s]", lower_case = TRUE,
#'                           EOS = ".?!:;")
#' freqs
#' ## 2-grams, no preprocessing, use a dictionary covering 50% of corpus
#' freqs <- kgram_freqs(corpus = twitter_train, N = 2, dict = target ~ 0.5,
#'                      EOS = ".?!:;")
#' freqs
#' }
################################################################################

kgram_freqs <- function(corpus, N, dict, .preprocess = identity, EOS = ""){
        N <- as.integer(N)
        checkargs_kgram_freqs()
        
        corpus <- .preprocess(corpus)
        if (EOS != "") corpus <- tokenize_sentences(corpus, EOS = EOS)
        
        dict <- make_dict(object = dict, .preprocess = identity, EOS = EOS,
                          corpus = corpus)
        
        freqs <- kgram_freqs_cpp(corpus, N, dict[])
        format_raw_freqs <- function(x){
                colnames(x) <- c(paste0("w", (N + 2 - ncol(x)):N), "n")
                as_tibble(x)
        }
        freqs <- lapply(freqs, format_raw_freqs)
        
        return(new_kgram_freqs(freqs = freqs, N = N, dict = dict,
                               .preprocess = .preprocess, EOS = EOS)
        )
}

checkargs_kgram_freqs <- function() {
        corpus <- N <- .preprocess <- erase <- lower_case <- EOS <- dict <- NULL 
        evalq({
                if (!is.character(corpus))
                        stop("'corpus' must be a character vector.")
                if (length(N) != 1 || is.na(N))
                        stop("'N' must be a length one integer.")
                if (N < 1L)
                        stop("'N' must be greater than one.")
                if (exists(".preprocess") && !is.function(.preprocess))
                        stop("'.preprocess' must be a function.")
                if (exists("erase") && 
                    !(is.character(erase) && length(erase) == 1)
                    ) 
                        stop("'erase' must be a length one character vector.")
                if (exists("lower_case") && 
                    !(is.logical(lower_case) && length(lower_case) == 1)
                    ) 
                        stop("'lower_case' must be a length one logical.")
                if (!is.character(EOS) || length(EOS) > 1)
                        stop("'EOS' must be a length one character vector.")
                if (!is_sbo_dictionary(dict) && 
                    !is.character(dict) && 
                    class(dict)[1] != "formula"
                    )
                        stop("'dict' must be either a 'sbo_dictionary', a
                             character vector or a formula.")
                }, 
              rlang::caller_env()
              )
}
