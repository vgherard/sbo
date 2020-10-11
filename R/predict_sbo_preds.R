#' Predict method for Stupid Back-off prediction tables
#'
#' Predictive text based on Stupid Back-off \eqn{latex}{N}-gram model.
#'
#' @export
#'
#' @author Valerio Gherardi
#' @md
#'
#' @param object a \code{sbo_preds} object.
#' @param input a character vector, containing the input for next-word prediction.
#' @param ... further arguments passed to or from other methods.
#' @return A character vector if \code{length(newdata) == 1}, otherwise a
#' character matrix.
#' @examples
#' predict(twitter_sbo, "i love")
#' @importFrom utils head
#' @importFrom utils tail
################################################################################
predict.sbo_preds <- function(object, input, ...){
        stopifnot(is.character(input) & length(input) > 0)
        input <- object$.preprocess(input)
        output <- predict_sbo_preds(object, input);
        if(nrow(output) == 1) return(as.character(output))
        else return(output)
}
