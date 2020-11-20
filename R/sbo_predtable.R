#' @rdname sbo_predictions
#' @export
sbo_predtable <- function(object, lambda = 0.4, L = 3L, filtered = "<UNK>", ...){
        if (!is.numeric(lambda) || length(lambda) != 1)
                stop("'lambda' must be a length one numeric.")
        if (lambda < 0 || lambda > 1)
                stop("'lambda' must be in the interval [0,1].")
        if (length(L <- as.integer(L)) != 1 || is.na(L))
                stop("'L' must be a length one integer.")
        if (L < 1) 
                stop("'L' must be greater than one.")
        if (!is.character(filtered)) 
                stop("'filtered' must be a character vector")
        UseMethod("sbo_predtable")
}

#' @rdname sbo_predictions
#' @export
#' @examples
#' \donttest{
#' # Build Stupid Back-Off prediction tables directly from corpus
#' t <- sbo_predtable(twitter_train, N = 3, dict = max_size ~ 1000, 
#'                    .preprocess = preprocess, EOS = ".?!:;")
#' }
sbo_predtable.character <- 
        function(object, N, dict, .preprocess = identity, EOS = "", 
                 lambda = 0.4, L = 3L, filtered = "<UNK>", ...) {
        freqs <- kgram_freqs(object, N = N, dict = dict, 
                             .preprocess = .preprocess, EOS = EOS)
        return(sbo_predtable(freqs, lambda, L, filtered))
}

#' @rdname sbo_predictions
#' @export
#' @examples
#' \donttest{
#' # Build Stupid Back-Off prediction tables from kgram_freqs object
#' t <- sbo_predtable(twitter_freqs)
#' }
#' \dontrun{
#' # Save and reload a 'sbo_predtable' object with base::save()
#' save(t)
#' load("t.rda")
#' }
sbo_predtable.sbo_kgram_freqs <- function(object, 
                                          lambda = 0.4, 
                                          L = 3L, filtered = "<UNK>", ...) {
        N <- attr(object, "N")
        dict <- attr(object, "dict")
        if (L > length(dict))
                stop("'L' must be less than the dictionary size.")
        
        EOS <- attr(object, "EOS")
        .preprocess <- attr(object, ".preprocess")
        
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
        
        preds <- lapply(build_pps(object, N, lambda, filtered, L), extract_preds)
        new_sbo_predtable(preds, 
                          N = N, dict = dict, lambda = lambda, L = L,
                          .preprocess = .preprocess, EOS = EOS
                          ) # return
}