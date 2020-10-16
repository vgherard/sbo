#' Predict method for Stupid Back-off prediction tables
#'
#' Predictive text based on Stupid Back-off N-gram model.
#'
#' @export
#'
#' @author Valerio Gherardi
#' @md
#'
#' @param object a \code{sbo_preds} object.
#' @param newdata a character vector, containing the input for next-word prediction.
#' @param ... further arguments passed to or from other methods.
#' @return A character vector if \code{length(newdata) == 1}, otherwise a
#' character matrix.
#' @examples
#' predict(twitter_preds, "i love")
################################################################################
predict.sbo_preds <- function(object, newdata, ...){
        stopifnot(is.character(newdata) & length(newdata) > 0)
        newdata <- object$.preprocess(newdata)
        output <- predict_sbo_preds(object, newdata);
        if (nrow(output) == 1) return(as.character(output))
        else return(output)
}
