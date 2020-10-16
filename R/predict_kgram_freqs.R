#' Predict method for k-gram frequency tables
#'
#' Predictive text based on Stupid Back-off N-gram model.
#'
#' @export
#'
#' @author Valerio Gherardi
#' @md
#
#' @param object a \code{kgram_freqs} object.
#' @param newdata a length one character vector, containing the input for
#' next-word prediction.
#' @param lambda a numeric vector of length one. The back-off penalization
#' in Stupid Back-off algorithm.
#' @param ... further arguments passed to or from other methods.
#' @return A tibble containing the next-word probabilities for all words
#' in the dictionary.
#' @examples
#' predict(twitter_freqs, "i love")
#' @importFrom utils head
#' @importFrom utils tail
################################################################################
predict.kgram_freqs <- function(object, newdata, lambda = 0.4, ...){
        stopifnot(is.character(newdata) & length(newdata) == 1)
        stopifnot(is.numeric(lambda) & length(lambda) == 1)
        N <- object$N
        dict <- object$dict
        EOS <- object$EOS
        V <- length(dict) + 3

        newdata <- object$.preprocess(newdata)
        newdata %<>% get_Ngram_prefix(N, dict, EOS) %>%
                `names<-`(paste0("w", 1:(N - 1)))

        FUN <- function(x){ x == newdata[[cur_column()]] }
        lapply(1:N, function(k)
                {object$counts[[k]] %>%
                        filter(across(any_of( names(newdata) ), FUN)) %>%
                        mutate(score = lambda^(N - k) * n / sum(n), k = k) %>%
                        select(all_of( paste0("w", N) ), score, k )
                }
               ) %>%
                bind_rows %>%
                group_by_at(vars(paste0("w",N))) %>%
                slice_max(order_by = k, n = 1, with_ties = FALSE) %>%
                ungroup %>%
                mutate(prob = score/sum(score)) %>%
                select(all_of(paste0("w",N)), prob) %>%
                arrange(desc(prob)) %>%
                mutate(across(all_of(paste0("w",N)),
                              function(x) c(dict,"<EOS>", "<UNK>")[x]
                              )
                       ) %>%
                `colnames<-`(c("completion", "probability")) %>%
                filter(completion != "<UNK>")
}
