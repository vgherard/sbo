################################################################################
#' Corpus preprocessing
#'
#' A basic text processing function, including sentence tokenization.
#'
#' @author Valerio Gherardi
#' @md
#'
#' @export
#'
#' @param text a character vector, containing the lines of text to be processed.
#' @param to_lower logical. If \code{TRUE}, put everything to lower case
#' @param replace_punct logical. If \code{TRUE}, any punctuation including
#' "\code{.?!:;}" gets replaced by a single dot.
#' @param erase_extra logical. If \code{TRUE}, anything not alpha-numeric,
#' white space, . or ' gets replaced by a single white space.
#' @param collapse_space logical. If \code{TRUE}, multiple white spaces are
#' collapsed to a single white space.
#' @param split_sent either \code{FALSE} or a character vector of length one.
#' In the second case, the input gets split in sentences separated by the token
#' represented by \code{split_sent}.
#' @param omit_empty logical. Omit empty sentences resulting from splitting?
#' (ineffective if \code{split_sent == FALSE})
#' @return A character vector. If \code{split_sent != FALSE}, each element of
#' the return value corresponds to a sentence, otherwise the original
#' structure of the input text is preserved.
#' @details This function provides basic utilities for preprocessing the
#' training corpus of a language model. The order of arguments
#' reflects the actual order of operations (e.g., the operations represented by
#' \code{replace_punct} and \code{erase_extra} do not commute).
#' @importFrom stringi stri_split_fixed

preprocess <- function(text, to_lower = TRUE, replace_punct = TRUE,
                  erase_extra = TRUE, collapse_space = TRUE,
                  split_sent = FALSE, omit_empty = TRUE){
        stopifnot(class(text) == "character")
        stopifnot(identical(split_sent, F) | is.character(split_sent))
        text %<>%
                {if(to_lower) tolower(.) else .} %>%
                gsub2('[[:space:]]*[.?!:;]+[[:space:]]*', '.',
                      only_if = replace_punct) %>%
                gsub2("[^a-z\'.[:space:]]", '', only_if = erase_extra) %>%
                gsub2('[[:space:]]+', ' ', only_if = collapse_space)
        if(is.character(split_sent)){ stopifnot(length(split_sent)==1)
                text %<>%
                        stri_split_fixed(split_sent, omit_empty=omit_empty) %>%
                        unlist
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
