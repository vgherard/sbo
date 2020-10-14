#' @export
#' @importFrom utils object.size

print.kgram_freqs <- function(x, ...){
        format_title <- . %>% (cli::style_underline) %>% (cli::style_bold)
        format_item <- . %>% (cli::col_silver) %>% (cli::style_italic)
        format_help <- . %>% (cli::col_green)
        "k-gram frequency table" %>%
                format_title %>%
                cat(., "\n\n")
        "Order (N):" %>%
                format_item %>%
                cat(., x$N, "\n")
        "Dictionary size:" %>%
                format_item %>%
                cat(., length(x$dict), " words\n\n")
        for(i in 1:x$N){
                paste0("# of unique ", i, "-grams:") %>%
                        format_item %>%
                        cat(., nrow( x$counts[[i]] ), "\n")
        }
        paste0("\nObject size:") %>%
                format_item %>%
                cat(., format(object.size(x), units = "MB"), "\n")
        cat("\n")
        "See ?get_kgram_freqs for help." %>% format_help %>% cat(., "\n")

        return(invisible(x))
}

#' @export
#' @importFrom utils object.size

print.sbo_preds <- function(x, ...){
        format_title <- . %>% (cli::style_underline) %>% (cli::style_bold)
        format_item <- . %>% (cli::col_silver) %>% (cli::style_italic)
        format_help <- . %>% (cli::col_green)
        "Next-word prediction table for Stupid Back-off n-gram model" %>%
                format_title %>%
                cat(., "\n\n")
        "Order (N):" %>%
                format_item %>%
                cat(., x$N, "\n")
        "Dictionary size:" %>%
                format_item %>%
                cat(., length(x$dict), " words\n")
        "Back-off penalization (lambda):" %>%
                format_item %>%
                cat(., x$lambda, "\n")
        "Maximum number of predictions (L):" %>%
                format_item %>%
                cat(., x$L, "\n")
        paste0("\nObject size:") %>%
                format_item %>%
                cat(., format(object.size(x), units = "MB"), "\n")
        cat("\n")

        "See ?build_sbo_preds, ?predict.sbo_preds for help." %>%
                format_help %>%
                cat(., "\n")

        return(invisible(x))
}
