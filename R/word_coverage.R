#' Word coverage fraction
#' 
#' Compute total and cumulative corpus coverage fraction of a dictionary.
#' @author Valerio Gherardi
#' @md
#' 
#' @export
#' 
#' @param object either a character vector, or an object inheriting from one of 
#' the classes \code{sbo_dictionary}, \code{sbo_kgram_freqs}, 
#' \code{sbo_predtable} or \code{sbo_predictor}. 
#' The object storing the dictionary for which corpus coverage is to be 
#' computed. 
#' @param corpus a character vector.
#' @param .preprocess preprocessing function for training corpus. See 
#' \code{\link[sbo]{kgram_freqs}} and \code{\link[sbo]{sbo_dictionary}} for
#' further details.
#' @param EOS a length one character vector. String containing End-Of-Sentence
#' characters, see  \code{\link[sbo]{kgram_freqs}} and 
#' \code{\link[sbo]{sbo_dictionary}} for further details.
#' @param ... further arguments passed to or from other methods.
#' @return a \code{word_coverage} object.

#' @details This function computes the corpus coverage fraction of a dictionary,
#' that is the fraction of words appearing in corpus which are contained in the
#' original dictionary.
#' 
#' This function is a generic, accepting as \code{object} argument any object 
#' storing a dictionary, along with a preprocessing function and a list 
#' of End-Of-Sentence characters. This includes all \code{sbo} main classes: 
#' \code{sbo_dictionary}, \code{sbo_kgram_freqs}, \code{sbo_predtable} and
#' \code{sbo_predictor}. When \code{object} is a character vector, the preprocessing
#' function and the End-Of-Sentence characters must be specified explicitly.
#' 
#' The coverage fraction is computed cumulatively, and the dependence of 
#' coverage with respect to maximal rank can be explored through \code{plot()}
#' (see examples below) 
#' @seealso \code{\link[sbo]{predict.sbo_predictor}}
#'
#' @name word_coverage 
word_coverage <- function(object, corpus, ...) 
        UseMethod("word_coverage")

#' @rdname word_coverage
#' @export
#' @examples 
#' \donttest{
#' c <- word_coverage(twitter_dict, twitter_train)
#' print(c)
#' summary(c)
#' # Plot coverage fraction, including the End-Of-Sentence in word counts.
#' plot(c, include_EOS = TRUE)
#' }
word_coverage.sbo_dictionary <- function(object, corpus, ...) {
        .preprocess <- attr(object, ".preprocess")
        EOS <- attr(object, "EOS")
        wfreqs <- kgram_freqs(corpus, 1, object, .preprocess, EOS)[[1]]
        wfreqs <- arrange(wfreqs, .data$w1)[["n"]]
        names(wfreqs) <- c(as.character(object), "<EOS>", "<UNK>")
        wfreqs <- c("<EOS>" = wfreqs[["<EOS>"]], wfreqs[-(length(wfreqs) - 1)])
        wfreqs <- cumsum(wfreqs / sum(wfreqs))
        wfreqs <- head(wfreqs, -1)
        return(new_word_coverage(wfreqs))
}

#' @rdname word_coverage
#' @export
word_coverage.character <- function(object, corpus, 
                                    .preprocess = identity, EOS = "", ...) 
{
        dict <- as_sbo_dictionary(object, .preprocess = .preprocess, EOS = EOS)
        return(word_coverage(dict, corpus = corpus))
}


word_coverage_sbo_generic <- function(object, corpus, ...) {
        dict <- attr(object, "dict")
        .preprocess <- attr(object, ".preprocess")
        EOS <- attr(object, "EOS")
        dict <- as_sbo_dictionary(dict, .preprocess = .preprocess, EOS = EOS)
        return(word_coverage(dict, corpus = corpus))
}

#' @rdname word_coverage
#' @export
word_coverage.sbo_kgram_freqs <- function(object, corpus, ...)
        return(word_coverage_sbo_generic(object, corpus = corpus))

#' @rdname word_coverage
#' @export
word_coverage.sbo_predictions <- function(object, corpus, ...)
        return(word_coverage_sbo_generic(object, corpus = corpus))