#' @export

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

print.sbo_predictions <- function(x, ...){
        what <- "text predictor"
        if (class(x)[1] == "sbo_predtable") what <- "prediction table"
        cat("A Stupid Back-Off", what, ".\n\n")
        paste0("See summary() for more details; ",
               "?predict.sbo_predictor for usage help."
        ) %>%
                (cli::col_green) %>%
                cat("\n")
        return(invisible(x))
}