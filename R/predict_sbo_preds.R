################################################################################
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
        .preprocess <- attr(object, ".preprocess")
        newdata <- .preprocess(newdata)
        if (!exists("ptr")) ptr <<- get_pc_ptr(object)
        output <- predict_sbo_preds(ptr, newdata);
        if (nrow(output) == 1) return(as.character(output))
        else return(output)
}
