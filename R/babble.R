################################################################################
#' Babble!
#'
#' Generate random text based on Stupid Back-off language model.
#'
#' @export
#'
#' @author Valerio Gherardi
#' @md
#'
#' @param model a \code{sbo_predictor} object.
#' @param input a length one character vector. Starting point for babbling!
#' If \code{NA}, as by default, a random word is sampled from the model's
#' dictionary.
#' @param n_max a length one integer. Maximum number of words to generate.
#' @param L a length one integer. Number of next-word suggestions from
#' which to sample (see details).
#' @return A character vector of length one.
#' @details This function generates random text from a Stupid Back-off language
#' model.
#' \code{babble} randomly samples one of the top L next word
#' predictions. Text generation stops when an End-Of-Sentence token is
#' encountered, or when the number of generated words exceeds n_max.
#' @examples
#' # Babble!
#' p <- sbo_predictor(twitter_predtable)
#' set.seed(840) # Set seed for reproducibility
#' babble(p)
################################################################################
babble <- function(model, input = NA, n_max = 100L, L = attr(model, "L")){
  stopifnot(is.na(input) | is.character(input) & length(input) == 1)
  stopifnot(length(n_max <- as.integer(n_max)) == 1)
  if (is.na(n_max) | n_max < 1L)
    stop("n_max could not be coerced to a positive integer")
  if (is.na(input))
    input <- sample(attr(model, "dict"), 1)
  if (n_max < 2L) return( paste(input,"[... reached maximum length ...]") )
  next_word <- sample(size = 1L, predict(model, input, L))
  if (next_word == "<EOS>") return(paste0(input,"."))
  babble(model, paste(input,next_word), n_max - 1L, L)
}
