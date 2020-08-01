# Basic text pre-processing.
#
# A basic text pre-processing function.
#
#' @param text a character vector, containing the lines of text to be processed.
#' @param to_lower logical. If \code{TRUE}, put everything to lower case
#' @param replace_punct logical. If \code{TRUE}, any punctuation including "\code{.?!:;}" gets
#' replaced by a single dot.
#' @param erase_extra logical. If \code{TRUE}, anything not alpha-numeric, white space,
#' . or ' gets replaced by a single white space.
#' @param collapse_space logical. If \code{TRUE}, multiple white spaces are collapsed to
#' a single white space.
#' @param split_sent either \code{FALSE} or a character vector of length one.
#' In the second case, the input gets split in sentences separated by the token
#' represented by \code{split_sent}.
#' @param omit_empty logical. Omit empty sentences resulting from splitting? (ineffective
#' if \code{split_sent == FALSE})
#' @param wrap either FALSE or a length two character vector. In the second case,
#' each sentence, or line of text if \code{split_sent == FALSE}, gets wrapped by
#' \code{wrap[[1]]} and \code{wrap[[2]]}.
#' @return A character vector.
#' @author Valerio Gherardi
#' @details This function provides basic utilities for preprocessing the
#' training corpus of a language model. It is currently the only option
#' available for use in \code{\link[sbo]{get_kgram_freqs}}.
#' Notice that the order of arguments
#' reflects the actual order of operations (e.g., the operations represented by
#' \code{replace_punct} and \code{erase_extra} do not commute). The additional
#' features \code{split_sent} and \code{wrap} allow for sentence tokenization
#' and wrapping each sentence with Begin-Of-Sentence/End-Of-Sentence tokens.
#' @importFrom stringi stri_split_fixed

preprocess <- function(text, to_lower = TRUE, replace_punct = TRUE,
                  erase_extra = TRUE, collapse_space = TRUE,
                  split_sent = FALSE, omit_empty = TRUE, wrap = FALSE){
        stopifnot(class(text)=="character")
        stopifnot(identical(split_sent, F) | is.character(split_sent))
        stopifnot(identical(wrap, F) | is.character(wrap))
        text %<>%
                {if(to_lower) tolower(.) else .} %>%
                gsub2('[[:space:]]*[.?!:;]+[[:space:]]*', '.',
                      only_if = replace_punct) %>%
                gsub2("[^a-z\'.[:space:]]", '', only_if = erase_extra) %>%
                gsub2('[[:space:]]+', ' ', only_if = collapse_space)
        if(is.character(split_sent)){ stopifnot(length(split_sent)==1)
                text %<>%
                        stri_split_fixed(split_sent, omit_empty= omit_empty) %>%
                        unlist
        }
        if(is.character(wrap)){ stopifnot(length(wrap) == 2)
                text %<>% paste(wrap[[1]], ., wrap[[2]], sep = " ")
        }
        text
}

# A pipe-friendly gsub alias with perl = TRUE as default
gsub2 <- function(string, pattern, replacement, only_if){
        if(only_if)
                gsub(pattern, replacement, string, perl = TRUE)
        else
                string
}
