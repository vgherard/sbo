new_sbo_predtable <- function(preds, N, dict, lambda, L, .preprocess, EOS) {
        stopifnot(is.list(preds), 
                  is.integer(N), is.character(dict),
                  is.numeric(lambda) && length(lambda) == 1,
                  is.integer(L) && length(L) == 1,
                  is.function(.preprocess), is.character(EOS))
        attributes(dict) <- NULL
        structure(preds, 
                  N = N, dict = dict, lambda = lambda, L = L,
                  .preprocess = .preprocess, EOS = EOS,
                  class = c("sbo_predtable", "sbo_predictions")
        ) # return
}
