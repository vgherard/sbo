################################################################################
#' Load Stupid Back-off text predictor.
#'
#' Load a \code{sbo_predictor} object from a \code{sbo_predtable}
#'
#' @author Valerio Gherardi
#' @md
#'
#' @export
#'
#' @param predtable a \code{sbo_predtable} object, obtained through 
#' \code{build_predtable()}.
#' @return A \code{sbo_predictor} object.
#' @details This function restores a Stupid Back-Off text predictor 
#' (i.e. a \code{sbo_predictor} object) from a "raw" prediction table 
#' (a \code{sbo_predtable} object). The latter objects provide a convenient way 
#' to store heavy N-gram models out of memory (e.g. with `save()`). 
#'
#' @seealso \code{\link[sbo]{build_predtable}}
#' @examples
#' \donttest{
#' # Load text predictor from sbo::twitter_predtable
#' p <- load_predictor(twitter_predtable)
#' p
#' predict(p, "i love")
#' }
################################################################################
load_predictor <- function(predtable) {
        stopifnot(is.object(predtable), class(predtable)[1] == "sbo_predtable")
        predictor <- get_pc_ptr(predtable)
        attributes(predictor) <- attributes(predtable)
        class(predictor) <- c("sbo_predictor", "sbo_predictions")
        return(predictor)
}