################################################################################
#' @rdname kgram_freqs
#' @export
#' @examples
#' \donttest{
#' # Obtain k-gram frequency table from corpus
#' ## Get k-gram frequencies, up to k = N = 3.
#' freqs <- kgram_freqs_fast(twitter_train, N = 3, dict = twitter_dict)
#' ## Print result
#' freqs
#' }
################################################################################
kgram_freqs_fast <- function(corpus, N, dict, 
                             erase = "", tolower = FALSE, EOS = ""){
        if (!is.character(corpus))
                stop("'corpus' must be a character vector.")
        N <- as.integer(N)
        if (length(N) != 1 || is.na(N))
                stop("'N' must be a length one integer.")
        if (N < 1L)
                stop("'N' must be greater than one.")
        if (!is.logical(TRUE) || length(tolower) > 1)
                stop("'tolower' must be a length one logical vector.")
        if (!is.character(EOS) || length(EOS) > 1)
                stop("'EOS' must be a length one character vector.")
        
        .preprocess <- function(x) preprocess(x, erase, tolower)
        
        if (is_sbo_dictionary(dict)) {
        } else if (is.character(dict)) {
                dict <- as_sbo_dictionary(dict, .preprocess, EOS)
        } else if (class(dict)[1] == "formula") {
                dict <- deparse(dict) %>% strsplit(" ~ ") %>% unlist
                args <- list(corpus = corpus, as.numeric(dict[2]), 
                             .preprocess = .preprocess, EOS = "")
                names(args)[2] <- dict[1]
                dict <- do.call(what = sbo_dictionary, args)
        } else {
                stop("Unexpected input for 'dict' argument.")
        }
        
        format_raw_freqs <- function(x){
                colnames(x) <- c(paste0("w", (N + 2 - ncol(x)):N), "n")
                as_tibble(x)
        }
        freqs <- lapply(kgram_freqs_fast_cpp(corpus, N, dict[], erase, tolower, EOS),
                        format_raw_freqs)

        return(new_kgram_freqs(freqs = freqs, N = N, dict = dict,
                               .preprocess = .preprocess, EOS = EOS)
               )
}
