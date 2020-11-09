#' @export
#' @importFrom utils object.size

print.kgram_freqs <- function(x, ...){
        cat("A k-gram frequency table.", "\n\n")
        paste0("See summary() for more details; ",
               "?predict.kgram_freqs for usage help."
               ) %>%
                (cli::col_green) %>%
                cat("\n")
        return(invisible(x))
}

#' @export
#' @importFrom utils object.size

print.sbo_preds <- function(x, ...){
        cat("A Stupid Back-Off prediction table.", "\n\n")
        paste0("See summary() for more details; ",
               "?predict.sbo_preds for usage help."
        ) %>%
                (cli::col_green) %>%
                cat("\n")
        return(invisible(x))
}
