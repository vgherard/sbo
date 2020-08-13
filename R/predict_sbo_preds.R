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
#' @param newdata a character vector, containing the input for next-word prediction.
#' @param L a length one integer. Number of predictions for each input sentence
#' (maximum allowed is \code{object$L}).
#' @param ... further arguments passed to or from other methods.
#' @return A character vector if \code{length(newdata) == 1}, otherwise a
#' character matrix.
#' @examples
#' predict(twitter_sbo, "i love")
#' @importFrom utils head
#' @importFrom utils tail
################################################################################
predict.sbo_preds <- function(object, newdata, L = object$L, ...){
        stopifnot(is.character(newdata) & length(newdata) > 0)
        stopifnot(is.integer(L) & length(L) == 1 & L <= object$L)
        N <- object$N
        dict <- object$dict
        V <- length(dict) + 3
        wrap <- c(paste0(rep("_BOS_", N-1), collapse = " "), "")

        if(length(newdata) > 1)
                return(sapply(newdata,
                              function(x)predict.sbo_preds(object, x, L)
                              ) %>% t
                       )
        newdata %<>%
                preprocess(split_sent = ".", omit_empty = F, wrap = wrap) %>%
                last %>%
                get_words(dict) %>%
                tail(N-1) %>%
                `names<-`(paste0("w",1:(N-1)))

        FUN <- function(x){ x == newdata[[cur_column()]] }
        for(k in N:1){
                preds <- object$preds[[k]] %>%
                        filter( across(starts_with("w"), FUN) ) %>%
                        select(starts_with("pred"))
                if(nrow(preds) == 0) next
                preds %<>% as.integer %>% head(L) %>% c(dict,".")[.]
                break
        }
        preds
}
