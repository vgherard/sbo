argcheck_kgram_freqs <- function() {
        corpus <- N <- .preprocess <- erase <- lower_case <- EOS <- dict <- NULL
        msg <- evalq({
                if (!is.character(corpus)) {
                        "'corpus' must be a character vector."
                } else if (!is.numeric(N) || length(N) != 1) {
                        "'N' must be a length one integer."
                } else if (N < 1L) {
                        "'N' must be greater than one."
                } else if (exists(".preprocess") && !is.function(.preprocess)) {
                        "'.preprocess' must be a function."
                } else if (exists("erase") && 
                           !(is.character(erase) && length(erase) == 1)
                           ) {
                        "'erase' must be a length one character vector."
                } else if (exists("lower_case") &&
                           !(is.logical(lower_case) && length(lower_case) == 1)
                           ) {
                        "'lower_case' must be a length one logical."
                } else if (!is.character(EOS) || length(EOS) > 1) {
                        "'EOS' must be a length one character vector."
                } else if (!is_sbo_dictionary(dict) &&
                           !is.character(dict) &&
                           class(dict)[1] != "formula"
                           ) {
                        paste("'dict' must be either a 'sbo_dictionary',",
                              "a character vector or a formula.")
                }
                },
                envir = rlang::caller_env()
                )
        if (!is.null(msg))
                rlang::abort(class = "sbo_domain_error", message = msg)
}
