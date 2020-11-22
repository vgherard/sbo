#' Coerce to dictionary
#'
#' Coerce objects to \code{sbo_dictionary} class. 
#' 
#' @author Valerio Gherardi
#' @md
#'
#' @param x object to be coerced.
#' @param .preprocess a function for corpus preprocessing.
#' @param EOS a length one character vector listing all (single character)
#' end-of-sentence tokens.
#' @param ... further arguments passed to or from other methods.
#' @return A \code{sbo_dictionary} object.
#' @details This function is an S3 generic for coercing existing objects to
#' \code{sbo_dictionary} class objects. Currently, only a method for character
#' vectors is implemented, and this will be described below.
#'  
#' \emph{\strong{Character vector input}}: 
#' Calling \code{as_sbo_dictionary(x)} simply decorates the character 
#' vector \code{x} with the class \code{sbo_dictionary} attribute, 
#' and with customizable \code{.preprocess} and \code{EOS} attributes.
#' @name as_sbo_dictionary
NULL

#' @rdname as_sbo_dictionary
#' @export
as_sbo_dictionary <- function(x, ...)
        UseMethod("as_sbo_dictionary")

#' @rdname as_sbo_dictionary
#' @export
#' @examples 
#' dict <- as_sbo_dictionary(c("a","b","c"), .preprocess = tolower, EOS = ".")
as_sbo_dictionary.character <- function(x, .preprocess = identity, EOS = "", ...) 
        return(new_sbo_dictionary(x, .preprocess, EOS))