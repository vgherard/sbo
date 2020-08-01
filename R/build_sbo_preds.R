################################################################################
#' Stupid Backoff predictions.
#'
#' Build Stupid Backoff prediction tables from \eqn{latex}{k}-gram
#' frequencies observed in a training corpus.
#'
#' @author Valerio Gherardi
#' @md
#'
#' @export
#' @importFrom tidyr pivot_wider
#'
#' @param freqs a \code{kgram_freqs} object, containing \eqn{latex}{k}-gram
#' frequencies extracted from a training corpus.
#' @param lambda a length one numeric. Penalization \eqn{latex}{\lambda} in the
#' Stupid Backoff algorithm.
#' @param L a length one integer. Maximum number of next-word predictions
#' for a given input.
#' @param filtered a character vector. Words to exclude from predictions.
#' @return A \code{sbo_preds} object.
#' @details This function compiles "prediction tables" from which top-scoring
#' next-word predictions of a Stupid Backoff language model can be read off.
#' This is done with the purposes of memory compression and efficiency.
#'
#' The return value is a \code{sbo_preds} object, i.e. a list containing:
#' 1. The order of the underlying \eqn{latex}{n}-gram model, "\code{n}".
#' 2. The maximum number of next-word predictions for a given text input.
#' 3. The model dictionary.
#' 4. A list of tibbles storing prediction tables. These are for internal use
#' in the \code{\link[sbo]{predict.sbo_preds}} method.
#' @seealso \code{\link[sbo]{predict.sbo_preds}}
#' @examples
#' # Train an n-gram model
#' ## Get Stupid Backoff prediction tables
#' sbo <- build_sbo_preds(twitter_freqs)
#' ## Print result
#' sbo
#' ## ...start playing
#' predict(sbo, "i love")
################################################################################

build_sbo_preds <- function(freqs, lambda = 0.4, L = 3L, filtered = "_UNK_"){
        n <- freqs$n
        dict <- freqs$dict
        V <- length(dict) + 2 # Dict. length including EOS and UNK.
        filtered %<>% match(table = c(dict, "_EOS_", "_UNK_"), nomatch = -1)

        pps_tbls <- build_pps_tables(freqs$counts, n, lambda, V, filtered, L)

        extract_preds <- . %>%
                select(-score) %>%
                group_by_at( vars(-pred) ) %>%
                mutate( rank = row_number() ) %>%
                ungroup %>%
                pivot_wider(names_from = rank, names_prefix = "pred",
                            values_from = pred) %>%
                mutate_all(as.integer)

        preds <- lapply(pps_tbls, . %>% extract_preds)

        structure(list(n = n, L = L, lambda = lambda, dict = dict,
                       preds = preds
                       ),
                  class = "sbo_preds"
                  )
}

