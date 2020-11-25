#' Predict method for k-gram frequency tables
#'
#' Predictive text based on Stupid Back-off N-gram model.
#'
#' @export
#'
#' @author Valerio Gherardi
#' @md
#
#' @param object a \code{sbo_kgram_freqs} object.
#' @param input a length one character vector, containing the input for
#' next-word prediction.
#' @param lambda a numeric vector of length one. The back-off penalization
#' in Stupid Back-off algorithm.
#' @param ... further arguments passed to or from other methods.
#' @return A tibble containing the next-word probabilities for all words
#' in the dictionary.
#' @examples
#' predict(twitter_freqs, "i love")
################################################################################
predict.sbo_kgram_freqs <- function(object, input, lambda = 0.4, ...){
        stopifnot(is.character(input) & length(input) == 1)
        stopifnot(is.numeric(lambda) & length(lambda) == 1)
        N <- attr(object, "N")
        dict <- attr(object, "dict")
        EOS <- attr(object, "EOS")
        .preprocess <- attr(object, ".preprocess")
        V <- length(dict) + 3

        input <- .preprocess(input) %>% get_kgram_prefix(N, dict, EOS)
        for (j in seq_along(input)) names(input)[[j]] <- paste0("w", j) 

        FUN <- function(x){ x == input[[cur_column()]] }
        lapply(1:N, function(k)
                {object[[k]] %>%
                        filter(across(any_of(names(input)), FUN)) %>%
                        mutate(score = lambda^(N - k) * n / sum(n), k = k) %>%
                        select(all_of(paste0("w", N)), .data$score, k )
                }
               ) %>%
                bind_rows %>%
                group_by_at(vars(paste0("w",N))) %>%
                slice_max(order_by = .data$k, n = 1, with_ties = FALSE) %>%
                ungroup %>%
                mutate(prob = .data$score/sum(.data$score)) %>%
                select(all_of(paste0("w",N)), .data$prob) %>%
                arrange(desc(.data$prob)) %>%
                mutate(across(all_of(paste0("w",N)),
                                     function(x) c(dict,"<EOS>", "<UNK>")[x]
                                     )
                       ) %>%
                `colnames<-`(c("completion", "probability")) %>%
                filter(.data$completion != "<UNK>") %>%
                arrange(desc(.data$probability), 
                        match(.data$completion, c(dict, "<EOS>"))
                        )
}
