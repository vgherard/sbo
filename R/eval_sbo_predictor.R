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
#' @param model a \code{sbo_predictor} object.
#' @param test a character vector. Perform a single prediction on each entry of
#' this vector (see details). 
#' @param L Maximum number of predictions for each input sentence
#' (maximum allowed is \code{attr(model, "L")})
#' @return A tibble, containing the input $(N-1)$-grams, the true completions,
#' the predicted completions and a column indicating whether one of the
#' predictions were correct or not.
#' @details This function allows to obtain information on the quality of 
#' Stupid Back-off model predictions, such as next-word prediction accuracy, 
#' or the word-rank distribution of correct prediction, by direct test against 
#' a test set corpus. For a reasonable estimate of prediction accuracy, the
#' different entries of the \code{test} vector should be uncorrelated 
#' documents (e.g. separate tweets, as in the \code{\link[sbo]{twitter_test}} 
#' example dataset).
#'
#' More in detail, \code{eval_sbo_predictor} performs the following operations:
#' 1. Sample a single sentence from each entry of the character vector 
#' \code{test}.
#' 1. Sample a single $N$-gram from each sentence obtained in the previous step.  
#' 1. Predict next words from the $(N-1)$-gram prefix.
#' 1. Return all predictions, together with the true word completions.
#' @examples
#' \donttest{
#' # Evaluating next-word predictions from a Stupid Back-off N-gram model
#' if (suppressMessages(require(dplyr) && require(ggplot2))) {
#'         p <- sbo_predictor(twitter_predtable)
#'         set.seed(840) # Set seed for reproducibility
#'         test <- sample(twitter_test, 500)
#'         eval <- eval_sbo_predictor(p, test)
#'         
#'         ## Compute three-word accuracies
#'         eval %>% summarise(accuracy = sum(correct)/n()) # Overall accuracy
#'         eval %>% # Accuracy for in-sentence predictions
#'                 filter(true != "<EOS>") %>%
#'                 summarise(accuracy = sum(correct) / n())
#'         
#'         ## Make histogram of word-rank distribution for correct predictions
#'         dict <- attr(twitter_predtable, "dict")
#'         eval %>%
#'                 filter(correct, true != "<EOS>") %>%
#'                 transmute(rank = match(true, table = dict)) %>%
#'                 ggplot(aes(x = rank)) + geom_histogram(binwidth = 30)
#' }
#' }
################################################################################

eval_sbo_predictor <- function(model, test, L = attr(model, "L")){
        msg <- if (!is.object(model) || class(model)[1] != "sbo_predictor") {
                "'model' must be a 'sbo_predictor' class object."
        } else if (!is.character(test)) {
                "'test' must be a character vector."
        } else if (length(test) < 1) {
                "'test' must be of length at least 1."
        } else if (!is.numeric(L) | length(L) != 1) {
                "'L' must be a length one integer."
        } else if (L < 1) {
                "'L' must be greater than one."
        } 
        if (!is.null(msg)) 
                rlang::abort(class = "sbo_domain_error", message = msg)
        
        test_kgrams <- sample_kgrams(model, test)
        
        if (nrow(test_kgrams) == 0) {
                return(tibble(input = character(), true = character(),
                              preds = matrix(nrow = 0, ncol = 3),
                              correct = logical(0))
                       )
        }
        
        
        
        test_kgrams %>%        
                group_by(row_number()) %>%
                mutate(preds = matrix(predict(model, .data$input)[1:L], ncol = L
                                      ),
                       correct = .data$true %in% .data$preds) %>%
                ungroup %>%
                select(.data$input, .data$true, .data$preds, .data$correct)
}

sample_kgrams <- function(model, test) {
        N <- attr(model, "N")
        wrap <- c(paste0(rep("<BOS>", N - 1), collapse = " "), "<EOS>")
        EOS <- attr(model, "EOS")
        test <- attr(model, ".preprocess")(test)
        
        lapply(test, function(x) {
                if (EOS != "") 
                        x <- tokenize_sentences(x, EOS = EOS)
                if (length(x) == 0) 
                        return(tibble(input = character(0), true = input))
                x <- sample(x, 1) %>% # sample one sentence
                        paste(wrap[[1]], ., wrap[[2]], sep = " ") %>%
                        strsplit(" ", fixed = TRUE) %>%
                        unlist %>%
                        .[. != ""]
                if (length(x) < N + 1) 
                        return(tibble(input = character(0), true = input))
                i <- sample(1:(length(x) - N + 1), 1) # sample one N-gram
                input <- paste0(x[i + seq_len(N - 1) - 1], collapse = " ")
                tibble(input = input, true = x[i + N - 1])
                }
               ) %>% # end lapply
                bind_rows %>%
                mutate(input = gsub("<BOS>", "", .data$input)) # return
}