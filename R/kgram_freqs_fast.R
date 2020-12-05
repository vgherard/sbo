################################################################################
#' @rdname kgram_freqs
#' @export
#' @examples
#' \donttest{
#' # Obtain k-gram frequency table from corpus
#' freqs <- kgram_freqs_fast(twitter_train, N = 3, dict = twitter_dict)
#' ## Print result
#' freqs
#' }
################################################################################
kgram_freqs_fast <- 
        function(corpus, N, dict, erase = "", lower_case = FALSE, EOS = ""){
        argcheck_kgram_freqs()
                
        N <- as.integer(N)
        .preprocess <- default_preprocess(erase, lower_case)
        dict <- make_dict(object = dict, .preprocess = .preprocess, EOS = EOS,
                          corpus = corpus)
        
        freqs <- kgram_freqs_fast_cpp(corpus, N, dict[], erase, lower_case, EOS)
        format_raw_freqs <- function(x){
                colnames(x) <- c(paste0("w", (N + 2 - ncol(x)):N), "n")
                as_tibble(x)
        }
        freqs <- lapply(freqs, format_raw_freqs)

        return(new_kgram_freqs(freqs = freqs, N = N, dict = dict,
                               .preprocess = .preprocess, EOS = EOS)
               )
}

default_preprocess <- function(erase, lower_case) {
        FUN <- function(x) preprocess(x, erase = erase, lower_case = lower_case)
        return(FUN)
}

#' @rdname kgram_freqs
#' @export
sbo_kgram_freqs_fast <- kgram_freqs_fast