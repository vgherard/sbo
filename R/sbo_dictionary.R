################################################################################
#' Dictionaries
#'
#' Build dictionary from training corpus.
#'
#' @author Valerio Gherardi
#' @md
#'
#' @export
#'
#' @param corpus a character vector. The training corpus from which to extract
#' the dictionary.
#' @param max_size a length one numeric. If less than \code{Inf}, only the most 
#' frequent \code{max_size} words are retained in the dictionary.
#' @param target a length one numeric between \code{0} and \code{1}. 
#' If less than one, retains 
#' only as many words as needed to cover a fraction \code{target} of the 
#' training corpus.
#' @param .preprocess a function for corpus preprocessing. Takes a character
#' vector as input and returns a character vector.
#' @param EOS a length one character vector listing all (single character)
#' end-of-sentence tokens.
#' @return A \code{sbo_dictionary} object.
#' @details The function \code{dictionary()} is an alias for 
#' \code{sbo_dictionary()}. 
#' 
#' This function builds a dictionary using the most frequent words in a 
#' training corpus. Two pruning criterions can be applied:
#' 
#' 1. Dictionary size, as implemented by the \code{max_size} argument.
#' 2. Target coverage fraction, as implemented by the \code{target} argument.
#' 
#' If both these criterions imply non-trivial cuts, the most restrictive 
#' critierion applies.
#' 
#' The \code{.preprocess} argument allows the user to apply a custom 
#' transformation to the training corpus, before word tokenization. The 
#' \code{EOS} argument allows to specify a set of characters to be identified
#' as End-Of-Sentence tokens (and thus not part of words).
#' 
#' The returned object is a \code{sbo_dictionary} object, which is a 
#' character vector containing words sorted by decreasing corpus frequency.
#' Furthermore, the object stores as attributes the original values of 
#' \code{.preprocess} and \code{EOS} (i.e. the function used in corpus 
#' preprocessing and the End-Of-Sentence characters for sentence tokenization).
#' @examples
#' \donttest{
#' # Extract dictionary from `twitter_train` corpus (all words)
#' dict <- sbo_dictionary(twitter_train)
#' # Extract dictionary from `twitter_train` corpus (top 1000 words)
#' dict <- sbo_dictionary(twitter_train, max_size = 1000)
#' # Extract dictionary from `twitter_train` corpus (coverage target = 50%)
#' dict <- sbo_dictionary(twitter_train, target = 0.5)
#' }
################################################################################
sbo_dictionary <- function(corpus, max_size = Inf, target = 1,
                           .preprocess = identity, EOS = "") {
        argcheck_sbo_dictionary()
        corpus <- .preprocess(corpus)
        if (EOS != "") corpus <- tokenize_sentences(corpus, EOS = EOS)
        wfreqs <- sort(get_word_freqsC(corpus), decreasing = TRUE)
        size <- min(max_size, length(wfreqs))
        if (target < 1) {
                wfreqs <- wfreqs / sum(wfreqs)
                size_cover <- which(cumsum(wfreqs) > target)[1]
                size <- min(size, size_cover)
        }
        dictionary <- names(wfreqs)[seq_len(size)]
        return(new_sbo_dictionary(dictionary, .preprocess, EOS))
}

#' @rdname sbo_dictionary
#' @export
dictionary <- sbo_dictionary

new_sbo_dictionary <- function(dictionary, .preprocess, EOS) {
        stopifnot(is.character(dictionary))
        stopifnot(is.function(.preprocess))
        stopifnot(is.character(EOS), length(EOS) == 1)
        structure(dictionary,
                  .preprocess = utils::removeSource(.preprocess), 
                  EOS = EOS,
                  class = "sbo_dictionary"
        ) # return
}

is_sbo_dictionary <- function(x) {
        is.object(x) &&
                (class(x) == "sbo_dictionary") &&
                (is.character(x)) &&
                setequal(names(attributes(x)),
                         c(".preprocess", "EOS", "class")
                         ) &&
                is.character(attr(x, "EOS")) && (length(attr(x, "EOS")) == 1) &&
                is.function(attr(x, ".preprocess"))
}