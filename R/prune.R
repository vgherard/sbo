#' Prune k-gram objects
#' 
#' Prune \code{M}-gram frequency tables or Stupid Back-Off prediction tables for
#' an \code{M}-gram model to a smaller order \code{N}. 
#' @author Valerio Gherardi
#' @md
#' 
#' @export
#' 
#' @param object A \code{\link[sbo]{kgram_freqs}} or a 
#' \code{\link[sbo]{sbo_predtable}} class object.
#' @param N a length one positive integer. N-gram order of the new object. 
#' @param ... further arguments passed to or from other methods.
#' @return an object of the same class of the input \code{object}.
#' @details This generic function provides a helper to prune M-gram frequency
#' tables or M-gram models, represented by \code{sbo_kgram_freqs} and 
#' \code{sbo_predtable} objects respectively, to objects of a smaller N-gram
#' order, N < M. For k-gram frequency objects, frequency tables for
#' k > N are simply dropped. For \code{sbo_predtable}'s, the predictions coming
#' from the nested N-gram model are instead retained. In both cases, all other
#' other attributes besides k-gram order (such as the corpus preprocessing 
#' function, or the \code{lambda} penalty in Stupid Back-Off training) are left
#' unchanged.
#'
#' @name prune
prune <- function(object, N, ...){
        if (!is.numeric(N) || length(N) > 1)
                rlang::abort(class = "sbo_domain_error", 
                             message = "'N' must be a length one numeric.")
        if (N < 1) rlang::abort(class = "sbo_domain_error",
                                message = "'N' must be greater than zero.")
        N_max <- attr(object, "N")
        if (N > N_max) 
                rlang::abort(class = "sbo_domain_error",
                             message = paste("'N' must be less than", N_max))
        UseMethod("prune")
}
        
#' @rdname prune
#' @export
#' @examples
#' # Drop k-gram frequencies for k > 2 
#' freqs <- twitter_freqs
#' summary(freqs)
#' freqs <- prune(freqs, N = 2)
#' summary(freqs)
prune.sbo_kgram_freqs <- function(object, N, ...) {
        N <- as.integer(N)
        .preprocess <- attr(object, ".preprocess")
        EOS <- attr(object, "EOS")
        dict <- as_sbo_dictionary(attr(object, "dict"), .preprocess, EOS)
        for (k in seq_len(N)) {
                word_labels <- paste0("w", (N + 1 - k):N)
                names(object[[k]]) <- c(word_labels, "n")
        }
        
        new_kgram_freqs(freqs = object[seq_len(N)],
                        N = N, dict = dict, .preprocess = .preprocess, EOS = EOS
                        ) # return
}

#' @rdname prune
#' @export
#' @examples
#' # Extract a 2-gram model from a larger 3-gram model 
#' pt <- twitter_predtable
#' summary(pt)
#' pt <- prune(pt, N = 2)
#' summary(pt)
prune.sbo_predtable <- function(object, N, ...) {
        for (k in seq_len(N - 1)) {
                word_labels <- paste0("w", (N - k):(N - 1))
                pred_labels <- paste0("prediction", 1:attr(object, "L"))
                colnames(object[[k + 1]]) <- c(word_labels, pred_labels)
        }
        new_sbo_predtable(preds = object[seq_len(N)], 
                          N = as.integer(N), 
                          dict = attr(object, "dict"), 
                          lambda = attr(object, "lambda"), 
                          L = attr(object, "L"), 
                          .preprocess = attr(object, ".preprocess"), 
                          EOS = attr(object, "EOS"))
}
