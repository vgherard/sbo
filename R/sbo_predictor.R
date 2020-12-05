#' @rdname sbo_predictions
#' @export
sbo_predictor <- function(object, ...)
        UseMethod("sbo_predictor")

#' @rdname sbo_predictions
#' @export
predictor <- sbo_predictor

#' @rdname sbo_predictions
#' @export
#' @examples
#' \donttest{
#' # Train a text predictor directly from corpus
#' p <- sbo_predictor(twitter_train, N = 3, dict = max_size ~ 1000,
#'                    .preprocess = preprocess, EOS = ".?!:;")
#' }
sbo_predictor.character <- function(object, N, dict, .preprocess = identity, 
                                    EOS = "", lambda = 0.4, L = 3L, 
                                    filtered = "<UNK>", ...) {
        predtable <- sbo_predtable(object, N = N, dict = dict, 
                                   .preprocess = .preprocess, EOS = EOS,
                                   lambda = lambda, L = L, filtered = filtered)
        return(sbo_predictor(predtable))
}

#' @rdname sbo_predictions
#' @export
#' @examples
#' \donttest{
#' # Train a text predictor from previously computed 'kgram_freqs' object
#' p <- sbo_predictor(twitter_freqs)
#' }
sbo_predictor.sbo_kgram_freqs <- function(object, lambda = 0.4, L = 3L, 
                                          filtered = "<UNK>", ...) {
        predtable <- sbo_predtable(object, lambda = lambda, L = L, 
                                   filtered = filtered)
        return(sbo_predictor(predtable))
}

#' @rdname sbo_predictions
#' @export
#' @examples
#' \donttest{
#' # Load a text predictor from a Stupid Back-Off prediction table
#' p <- sbo_predictor(twitter_predtable)
#' }
#' \donttest{
#' # Predict from Stupid Back-Off text predictor
#' p <- sbo_predictor(twitter_predtable)
#' predict(p, "i love")
#' }
sbo_predictor.sbo_predtable <- function(object, ...){
        predictor <- get_pc_ptr(object)
        attributes(predictor) <- attributes(object)
        class(predictor) <- c("sbo_predictor", "sbo_predictions")
        return(predictor)
}