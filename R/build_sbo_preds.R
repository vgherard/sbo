################################################################################
#' Stupid Back-off predictions.
#'
#' Build Stupid Back-off prediction tables from k-gram
#' frequencies observed in a training corpus.
#'
#' @author Valerio Gherardi
#' @md
#'
#' @export
#' @importFrom tidyr pivot_wider
#'
#' @param freqs a \code{kgram_freqs} object, containing k-gram
#' frequencies extracted from a training corpus.
#' @param lambda a length one numeric. Penalization in the
#' Stupid Back-off algorithm.
#' @param L a length one integer. Maximum number of next-word predictions
#' for a given input.
#' @param filtered a character vector. Words to exclude from predictions.
#' @return A \code{sbo_preds} object.
#' @details This function compiles "prediction tables" from which top-scoring
#' next-word predictions of a Stupid Back-off language model can be read off.
#' This is done with the purposes of memory compression and efficiency.
#'
#' The return value is a \code{sbo_preds} object, i.e. a list containing:
#' 1. The order of the underlying N-gram model, "\code{N}".
#' 2. The maximum number of next-word predictions for a given text input.
#' 3. The model dictionary.
#' 4. A list of tibbles storing prediction tables. These are for internal use
#' in the \code{\link[sbo]{predict.sbo_preds}} method.
#' 5. The function used for text preprocessing.
#' 6. A length one character vector listing all (single character)
#' end-of-sentence tokens.

#' @seealso \code{\link[sbo]{predict.sbo_preds}}
#' @examples
#' \donttest{
#' # Train an N-gram model
#' ## Get Stupid Back-off prediction tables
#' preds <- build_sbo_preds(twitter_freqs)
#' ## Print result
#' preds
#' ## ...start playing
#' predict(preds, "i love")
#' }
################################################################################

build_sbo_preds <- function(freqs, lambda = 0.4, L = 3L, filtered = "<UNK>"){
        N <- freqs$N
        dict <- freqs$dict
        V <- length(dict) + 2 # Dict. length including EOS and UNK.
        filtered %<>% match(table = c(dict, "<EOS>", "<UNK>"), nomatch = -1)

        pps_tbls <- build_pps_tables(freqs$counts, N, lambda, V, filtered, L)

        extract_preds <- . %>%
                select(-score) %>%
                group_by_at( vars(-pred) ) %>%
                mutate( rank = row_number() ) %>%
                ungroup %>%
                pivot_wider(names_from = rank, names_prefix = "pred",
                            values_from = pred) %>%
                mutate_all(as.integer) %>%
                as.matrix

        preds <- lapply(pps_tbls, . %>% extract_preds)

        structure(list(N = N, L = L, lambda = lambda, dict = dict, preds = preds,
                       .preprocess = freqs$.preprocess, EOS = freqs$EOS
                       ),
                  class = "sbo_preds"
                  )
}
