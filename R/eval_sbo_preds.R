################################################################################
#' Evaluate Stupid Backoff next-word predictions
#'
#' Evaluate next-word predictions based on Stupid Backoff \eqn{latex}{n}-gram
#' model on a test corpus.
#'
#' @author Valerio Gherardi
#' @md
#'
#' @export
#'
#' @param model a \code{sbo_preds} object.
#' @param test a character vector. Test corpus for model evaluation.
#' @param L Maximum number of predictions for each input sentence
#' (maximum allowed is \code{model$L})
#' @return A tibble, containing the input $(n-1)$-grams, the true completions,
#' the predicted completions and a column indicating whether one of the
#' predictions were correct or not.
#' @details This function allows to obtain information on Stupid Backoff model
#' predictions, such as next-word prediction accuracy, or the word-rank
#' distribution of correct prediction, by direct test against a test set corpus.
#'
#' \code{eval_sbo_preds} performs the following operations:
#' 1. Sample a single $n$-gram from each sentence of test corpus.
#' 1. Predict next words from the $(n-1)$-gram prefix.
#' 1. Return all predictions, together with the true word completions.
#' @examples
#' # Evaluating next-word predictions from a Stupid Backoff n-gram model
#'
#' set.seed(840) # Set seed for reproducibility
#' eval <- # May take ~ 2 or 3 minutes!
#'         eval_sbo_preds(twitter_sbo, twitter_test, L = 3)
#'
#' ## Compute three-word accuracies
#' eval %>% summarise(accuracy = sum(correct)/n()) # Overall accuracy
#' eval %>% # Accuracy for in-sentence predictions
#'         filter(true != ".") %>%
#'        summarise(accuracy = sum(correct)/n())
#'
#' ## Make histogram of word-rank distribution for correct predictions
#' if(require(ggplot2)){
#'         eval %>% ###
#'                 filter(correct, true != ".") %>%
#'                 transmute(rank = match(true, table = twitter_sbo$dict)) %>%
#'                 ggplot(aes(x = rank)) + geom_histogram(binwidth = 25)
#' }
#' @importFrom stats predict
################################################################################

eval_sbo_preds <- function(model, test, L = model$L){
        stopifnot(is.character(test))
        if(is.na((L %<>% as.integer)) | L < 1L)
                stop("L could not be coerced to a positive integer")
        n <- model$n
        dict <- model$dict
        wrap <- c(paste0(rep("_BOS_", n-1), collapse = " "), "_EOS_")
        test %>%
                preprocess(split_sent = ".", wrap = wrap) %>%
                lapply(function(x){
                        x %<>% stri_split_fixed(" ", omit_empty=TRUE) %>% unlist
                        if(length(x) < n + 1) return(tibble())
                        i <- sample(1:(length(x)-n+1), 1)
                        input <- paste0(x[i:(i+n-2)], collapse = " ")
                        tibble(input = input, true = x[i+n-1] )
                        }) %>%
                bind_rows %>%
                mutate(input = gsub("_BOS_", "", input),
                       true = gsub("_EOS_", ".", true) ) %>%
                group_by(row_number()) %>%
                mutate(preds = sapply(input,
                                      function(x) list(predict(model, x, L))
                                      ),
                       correct = true %in% unlist(preds) ) %>%
                ungroup %>%
                select(input, true, preds, correct)
}
