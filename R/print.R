#' @export

print.sbo_dictionary <- function(x, ...){
        cat(paste0("A dictionary.", "\n\n"))
        paste0("See summary() for more details.\n") %>% (cli::col_green) %>% cat
        return(invisible(x))
}

#' @export

print.sbo_kgram_freqs <- function(x, ...){
        cat(paste0("A k-gram frequency table.", "\n\n"))
        paste0("See summary() for more details; ",
               "?predict.sbo_kgram_freqs for usage help.\n"
               ) %>%
                (cli::col_green) %>%
                cat
        return(invisible(x))
}

#' @export

print.sbo_predictions <- function(x, ...){
        what <- "text predictor"
        if (class(x)[1] == "sbo_predtable") what <- "prediction table"
        cat(paste0("A Stupid Back-Off ", what, ".\n\n"))
        paste0("See summary() for more details; ",
               "?predict.sbo_predictor for usage help.\n"
        ) %>%
                (cli::col_green) %>%
                cat
        return(invisible(x))
}

#' @export
print.word_coverage <- function(x, ...){
        cat("A 'word_coverage' object.\n\n")
        paste0("See summary() for more details.\n") %>% (cli::col_green) %>% cat
        return(invisible(x))
}