#' @export

summary.sbo_dictionary <- function(object, ...){
        format_title <- . %>% (cli::style_underline) %>% (cli::style_bold)
        format_item <- . %>% (cli::col_silver) %>% (cli::style_italic)
        format_help <- . %>% (cli::col_green)
        
        "Dictionary\n\n" %>% format_title %>% cat
        
        "A `sbo_dictionary` of length:" %>% format_item %>% cat(length(object))
        cat("\n")
        head(object, 10) %>% (cli::style_italic) %>% cat("...", sep = ", ")
        
        return(invisible(object))
}

#' @export

summary.sbo_kgram_freqs <- function(object, ...){
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
        "See ?predict.sbo_kgram_freqs for usage help." %>% format_help %>% cat("\n")
        
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

#' @export
summary.word_coverage <- function(object, ...){
        format_title <- . %>% (cli::style_underline) %>% (cli::style_bold)
        format_item <- . %>% (cli::col_silver) %>% (cli::style_italic)
        format_help <- . %>% (cli::col_green)
        
        "Word coverage fraction\n\n" %>% format_title %>% cat
        
        f_w_EOS <- format(100 * last(object), digits = 3)
        f_wo_EOS <- 
                (100 * (last(object) - object[[1]]) / (1 - object[[1]])) %>% 
                format(digits = 3)
        
        "Dictionary length:" %>% format_item %>% cat(length(object) - 1, "\n")
        "Coverage fraction (w/ EOS):" %>% format_item %>% cat(f_w_EOS, "%\n")
        "Coverage fraction (w/o EOS):" %>% format_item %>% cat(f_wo_EOS, "%\n")
        
        return(invisible(object))
}