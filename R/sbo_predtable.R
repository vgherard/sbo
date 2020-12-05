#' @rdname sbo_predictions
#' @export
sbo_predtable <- function(object, lambda = 0.4, L = 3L, filtered = "<UNK>", ...){
        error <- function(msg)
                rlang::abort(class = "sbo_domain_error", message = msg)  
        if (!is.numeric(lambda) || length(lambda) != 1)
                error("'lambda' must be a length one numeric.")
        if (lambda < 0 || lambda > 1)
                error("'lambda' must be in the interval [0,1].")
        if (!is.numeric(L) || length(L) != 1)
                error("'L' must be a length one integer.")
        if (L < 1) 
                error("'L' must be greater than one.")
        if (!is.character(filtered)) 
                error("'filtered' must be a character vector")
        UseMethod("sbo_predtable")
}

#' @rdname sbo_predictions
#' @export
predtable <- sbo_predtable

#' @rdname sbo_predictions
#' @export
#' @examples
#' \donttest{
#' # Build Stupid Back-Off prediction tables directly from corpus
#' t <- sbo_predtable(twitter_train, N = 3, dict = max_size ~ 1000, 
#'                    .preprocess = preprocess, EOS = ".?!:;")
#' }
sbo_predtable.character <- 
        function(object, lambda = 0.4, L = 3L, filtered = "<UNK>",
                 N, dict, .preprocess = identity, EOS = "", ...) 
{
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
        L <- as.integer(L)
        
        EOS <- attr(object, "EOS")
        .preprocess <- attr(object, ".preprocess")
        
        filtered <- unique(intersect(filtered, c(dict, "<EOS>", "<UNK>")))
        max_L <- length(dict) + 2 - length(filtered)
        filtered <- match(filtered, table = c(dict, "<EOS>", "<UNK>"))
        
        if (max_L == 0) rlang::abort(
                class = "sbo_domain_error",
                message = "No words allowed for prediction!"
                )
        if (L > max_L) rlang::abort(
                class = "sbo_domain_error",
                message = paste0("'L' must be less than ", max_L)
                )
        
        extract_preds <- . %>% 
                select(-.data$score) %>%
                group_by_at(vars(-.data$prediction)) %>%
                mutate(rank = row_number()) %>%
                ungroup %>%
                tidyr::pivot_wider(names_from = .data$rank, 
                                   names_prefix = "prediction", 
                                   values_from = .data$prediction
                ) %>%
                as.matrix
        
        preds <- lapply(build_pps(object, N, lambda, filtered, L), extract_preds)
        new_sbo_predtable(preds, 
                          N = N, dict = dict, lambda = lambda, L = L,
                          .preprocess = .preprocess, EOS = EOS
                          ) # return
}