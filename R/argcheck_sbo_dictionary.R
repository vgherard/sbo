argcheck_sbo_dictionary <- function() {
        corpus <- max_size <- target <- .preprocess <- EOS <- NULL
        msg <- evalq({
                if (!is.character(corpus)) {
                        "'corpus' must be a character vector."
                } else if (!is.numeric(max_size) || length(max_size) > 1) {
                        "'max_size' must be a length one numeric."
                } else if (max_size < 0) {
                        "'max_size' must be positive."
                } else if (!is.numeric(target) || length(target) > 1) {
                        "'target' must be a length one numeric."       
                } else if (!(0 <= target && target <= 1)) {
                        "'target' must lie in the [0,1] interval."
                } else if (!is.function(.preprocess)) {
                        "'.preprocess' must be a function."
                } else if (!is.character(EOS) || length(EOS) > 1) {
                        "'EOS' must be a length one character vector."
                }
                },
                envir = rlang::caller_env()
                )
        if (!is.null(msg))
                rlang::abort(class = "sbo_domain_error", message = msg)
}
