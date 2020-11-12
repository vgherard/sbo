################################################################################
#' @rdname sbo_predictions
#' @export
#' @examples
#' \donttest{
#' # Train a text predictor with Stupid Back-Off
#' ## Get Stupid Back-off prediction tables
#' p <- train_predictor(twitter_freqs)
#' p
#' predict(p, "i love")
#' }
################################################################################

train_predictor <- function(freqs, lambda = 0.4, L = 3L, filtered = "<UNK>") {
        predtable <- build_predtable(freqs, lambda, L, filtered)
        return(load_predictor(predtable))
}