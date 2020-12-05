################################################################################
#' Stupid Back-off text predictions
#'
#' Train a text predictor via Stupid Back-off
#'
#' @author Valerio Gherardi
#' @md
#'
#' @param object either a character vector or an object inheriting from classes 
#' \code{sbo_kgram_freqs} or \code{sbo_predtable}. Defines the method to use for
#' training.
#' @param N a length one integer. Order 'N' of the N-gram model.
#' @param dict a \code{sbo_dictionary}, a character vector or a formula. For
#' more details see \code{\link[sbo]{kgram_freqs}}.
#' @param .preprocess a function for corpus preprocessing. For
#' more details see \code{\link[sbo]{kgram_freqs}}.
#' @param EOS a length one character vector. String listing End-Of-Sentence
#' characters. For more details see \code{\link[sbo]{kgram_freqs}}.
#' @param lambda a length one numeric. Penalization in the
#' Stupid Back-off algorithm.
#' @param L a length one integer. Maximum number of next-word predictions
#' for a given input (top scoring predictions are retained).
#' @param filtered a character vector. Words to exclude from next-word 
#' predictions. The strings '<UNK>' and '<EOS>' are reserved keywords 
#' referring to the Unknown-Word and End-Of-Sentence tokens, respectively.
#' @param ... further arguments passed to or from other methods.
#' @return A \code{sbo_predictor} object for \code{sbo_predictor()}, a 
#' \code{sbo_predtable} object for \code{sbo_predtable()}.
#' @details These functions are generics used to train a text predictor 
#' with Stupid Back-Off. The functions \code{predictor()} and 
#' \code{predtable()} are aliases for \code{sbo_predictor()} and 
#' \code{sbo_predtable()}, respectively.
#' 
#' The \code{sbo_predictor} data structure carries 
#' all information 
#' required for prediction in a compact and efficient (upon retrieval) way, 
#' by directly storing the top \code{L} next-word predictions for each
#' k-gram prefix observed in the training corpus.
#' 
#' The \code{sbo_predictor} objects are for interactive use. If the training
#' process is computationally heavy, one can store a "raw" version of the 
#' text predictor in a \code{sbo_predtable} class object, which can be safely 
#' saved out of memory (with e.g. \code{save()}). 
#' The resulting object can be restored
#' in another R session, and the corresponding \code{sbo_predictor} object
#' can be loaded rapidly using again the generic constructor 
#' \code{sbo_predictor()} (see example below).
#' 
#' The returned objects are a \code{sbo_predictor} and a \code{sbo_predtable} 
#' objects.
#' The latter contains Stupid Back-Off prediction tables, storing next-word 
#' prediction for each k-gram prefix observed in the text, whereas the former
#' is an external pointer to an equivalent (but processed) C++ structure.
#' 
#' Both objects have the following attributes: 
#' - \code{N}: The order of the underlying N-gram model, "\code{N}".
#' - \code{dict}: The model dictionary.
#' - \code{lambda}: The penalization used in the Stupid Back-Off algorithm.
#' - \code{L}: The maximum number of next-word predictions for a given text 
#' input.
#' - \code{.preprocess}: The function used for text preprocessing.
#' - \code{EOS}: A length one character vector listing all (single character)
#' end-of-sentence tokens.

#' @seealso \code{\link[sbo]{predict.sbo_predictor}}
#'
#' @name sbo_predictions 
################################################################################
NULL