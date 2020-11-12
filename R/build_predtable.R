################################################################################
#' @rdname sbo_predictions
#' @export
#' @examples
#' \donttest{
#' # Build Stupid Back-Off prediction tables
#' t <- build_predtable(twitter_freqs)
#' p <- load_predictor(t) # Load text predictor
#' predict(p, "i love")
#' ## Use `save(t)` to save prediction tables for the next R session
#' }
################################################################################

build_predtable <- function(freqs, lambda = 0.4, L = 3L, filtered = "<UNK>") {
        N <- attr(freqs, "N")
        dict <- attr(freqs, "dict")
        EOS <- attr(freqs, "EOS")
        .preprocess <- attr(freqs, ".preprocess")
        
        filtered <- match(filtered, table = c(dict, "<EOS>", "<UNK>"), 
                          nomatch = -1)
        
        extract_preds <- . %>% 
                select(-score) %>%
                group_by_at(vars(-prediction)) %>%
                mutate(rank = row_number()) %>%
                ungroup %>%
                tidyr::pivot_wider(names_from = rank, 
                                   names_prefix = "prediction", 
                                   values_from = prediction
                ) %>%
                as.matrix
        
        preds <- lapply(build_pps(freqs, N, lambda, filtered, L), extract_preds)
        structure(preds, 
                  N = N, dict = dict, lambda = lambda, L = L,
                  .preprocess = .preprocess, EOS = EOS,
                  class = c("sbo_predtable", "sbo_predictions")
        ) # return
}