################################################################################
#' Predict method for Stupid Back-off text predictor
#'
#' Predictive text based on Stupid Back-off N-gram model.
#'
#' @export
#'
#' @author Valerio Gherardi
#' @md
#'
#' @param object a \code{sbo_predictor} object.
#' @param input a character vector, containing the input for next-word prediction.
#' @param ... further arguments passed to or from other methods.
#' @return A character vector if \code{length(input) == 1}, otherwise a
#' character matrix.
#' @details This method returns the top \code{L} next-word predictions from a
#' text predictor trained with Stupid Back-Off.
#' 
#' Trying to predict from a \code{sbo_predtable} results into an error. Instead,
#' one should load a \code{sbo_predictor} object and use this one to predict(), 
#' as shown in the example below. 
#' @examples
#' p <- sbo_predictor(twitter_predtable)
#' x <- predict(p, "i love")
#' x
#' x <- predict(p, "you love")
#' x
#' #N.B. the top predictions here are x[1], followed by x[2] and x[3].
#' predict(p, c("i love", "you love")) # Behaviour with length()>1 input.
################################################################################
predict.sbo_predictor <- function(object, input, ...){
        stopifnot(is.character(input) & length(input) > 0)
        .preprocess <- attr(object, ".preprocess")
        input <- .preprocess(input)
        output <- predict_sbo_predictor(object, input)
        if (nrow(output) == 1) return(as.character(output))
        else return(output)
}

#' @export
predict.sbo_predtable <- function(object, input, ...){
        stop("Cannot predict() from 'sbo_predtable' class object. ",
             "Use 'sbo_predictor()' to set up a 'sbo_predictor' object.")
}
