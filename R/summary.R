#' @export

summary.kgram_freqs <- function(object, ...){
        format_title <- . %>% (cli::style_underline) %>% (cli::style_bold)
        format_item <- . %>% (cli::col_silver) %>% (cli::style_italic)
        format_help <- . %>% (cli::col_green)
        N <- attr(object, "N")
        dict_length <- length(attr(object, "dict"))
        size <- format(object.size(object), units = "MB")
        
        "k-gram frequency table" %>%
                format_title %>%
                cat(., "\n\n")
        "Order (N):" %>% format_item %>% cat(N, "\n")
        "Dictionary size:" %>% format_item %>% cat(dict_length, " words\n\n")
        for (i in 1:N) {
                paste0("# of unique ", i, "-grams:") %>%
                        format_item %>%
                        cat(nrow(object[[i]] ), "\n")
        }
        paste0("\nObject size:") %>%
                format_item %>%
                cat(size, "\n")
        cat("\n")
        "See ?predict.kgram_freqs for usage help." %>% format_help %>% cat("\n")

        return(invisible(object))
}

#' @export

summary.sbo_preds <- function(object, ...){
        format_title <- . %>% (cli::style_underline) %>% (cli::style_bold)
        format_item <- . %>% (cli::col_silver) %>% (cli::style_italic)
        format_help <- . %>% (cli::col_green)
        N <- attr(object, "N")
        dict_length <- length(attr(object, "dict"))
        lambda <- attr(object, "lambda")
        L <- attr(object, "L")
        size <- format(object.size(object), units = "MB")
        "Next-word prediction table for Stupid Back-off n-gram model" %>%
                format_title %>%
                cat(., "\n\n")
        "Order (N):" %>% format_item %>% cat(N, "\n")
        "Dictionary size:" %>% format_item %>% cat(dict_length, " words\n")
        "Back-off penalization (lambda):" %>% format_item %>% cat(lambda, "\n")
        "Maximum number of predictions (L):" %>% format_item %>% cat(L, "\n")
        cat("\n")
        "Object size:" %>% format_item %>% cat(size, "\n")
        cat("\n")
        "See ?predict.sbo_preds for usage help." %>% format_help %>% cat("\n")

        return(invisible(object))
}
