################################################################################
#' Evaluate Stupid Back-off next-word predictions
#'
#' Evaluate next-word predictions based on Stupid Back-off N-gram
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
#' @return A tibble, containing the input $(N-1)$-grams, the true completions,
#' the predicted completions and a column indicating whether one of the
#' predictions were correct or not.
#' @details This function allows to obtain information on Stupid Back-off model
#' predictions, such as next-word prediction accuracy, or the word-rank
#' distribution of correct prediction, by direct test against a test set corpus.
#'
#' \code{eval_sbo_preds} performs the following operations:
#' 1. Sample a single $N$-gram from each sentence of test corpus.
#' 1. Predict next words from the $(N-1)$-gram prefix.
#' 1. Return all predictions, together with the true word completions.
#' @examples
#' \donttest{
#' # Evaluating next-word predictions from a Stupid Back-off N-gram model
#'
#' set.seed(840) # Set seed for reproducibility
#' eval <- # May take ~ 2 or 3 minutes!
#'         eval_sbo_preds(twitter_preds, twitter_test, L = 3)
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
#'                 transmute(rank = match(true, table = twitter_preds$dict)) %>%
#'                 ggplot(aes(x = rank)) + geom_histogram(binwidth = 25)
#' }
#' }
#' @importFrom stats predict
#' @importFrom stringi stri_split_fixed
################################################################################

eval_sbo_preds <- function(model, test, L = model$L){
        stopifnot(is.character(test))
        if(is.na((L %<>% as.integer)) | L < 1L)
                stop("L could not be coerced to a positive integer")
        N <- model$N
        dict <- model$dict
        wrap <- c(paste0(rep("<BOS>", N-1), collapse = " "), "<EOS>")
        test %>%
                (model$.preprocess) %>%
                tokenize_sentences(EOS = model$EOS) %>%
                paste(wrap[[1]], ., wrap[[2]], sep = " ") %>%
                lapply(function(x){
                        x %<>% stri_split_fixed(" ", omit_empty=TRUE) %>% unlist
                        if(length(x) < N + 1) return(tibble())
                        i <- sample(1:(length(x)-N+1), 1)
                        input <- paste0(x[i:(i+N-2)], collapse = " ")
                        tibble(input = input, true = x[i+N-1] )
                        }) %>%
                bind_rows %>%
                mutate(input = gsub("<BOS>", "", input)) %>%
                group_by(row_number()) %>%
                # mutate(preds = sapply(input,
                #                       function(x) list(predict(model, x, L))
                #                       ),
                #        correct = true %in% unlist(preds) ) %>%
                mutate(preds = matrix(predict(model, input), ncol = L),
                       correct = true %in% preds) %>%
                ungroup %>%
                select(input, true, preds, correct)
}
