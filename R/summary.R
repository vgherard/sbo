#' @export

summary.sbo_kgramfreqs <- function(object, ...){
        format_title <- . %>% (cli::style_underline) %>% (cli::style_bold)
        format_item <- . %>% (cli::col_silver) %>% (cli::style_italic)
        format_help <- . %>% (cli::col_green)
        N <- attr(object, "N")
        dict_length <- length(attr(object, "dict"))
        size <- format(utils::object.size(object), units = "MB")
        
        "k-gram frequency table\n\n" %>% format_title %>% cat
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
        "See ?predict.sbo_kgramfreqs for usage help." %>% format_help %>% cat("\n")
        
        return(invisible(object))
}

#' @export
summary.sbo_predictions <- function(object, ...){
        what <- "text predictor"
        if (class(object)[1] == "sbo_predtable") what <- "prediction table"
        format_title <- . %>% (cli::style_underline) %>% (cli::style_bold)
        format_item <- . %>% (cli::col_silver) %>% (cli::style_italic)
        format_help <- . %>% (cli::col_green)
        N <- attr(object, "N")
        dict_length <- length(attr(object, "dict"))
        lambda <- attr(object, "lambda")
        L <- attr(object, "L")
        paste("Next-word", what, "from Stupid Back-off N-gram model\n\n") %>%
                format_title %>%
                cat
        "Order (N):" %>% format_item %>% cat(N, "\n")
        "Dictionary size:" %>% format_item %>% cat(dict_length, " words\n")
        "Back-off penalization (lambda):" %>% format_item %>% cat(lambda, "\n")
        "Maximum number of predictions (L):" %>% format_item %>% cat(L, "\n")
        cat("\n")
        if (what == "prediction table") {
                size <- format(utils::object.size(object), units = "MB")
                "Object size:" %>% format_item %>% cat(size, "\n")
                cat("\n")
        }
        "See ?predict.sbo_predictor for usage help.\n" %>% format_help %>% cat
        
        return(invisible(object))
}
