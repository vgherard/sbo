################################################################################
#' Stupid Back-off text predictions.
#'
#' Train a text predictor via Stupid Back-off
#'
#' @author Valerio Gherardi
#' @md
#'
#' @param freqs a \code{sbo_kgram_freqs} object obtained with 
#' \code{\link[sbo]{kgram_freqs}}, containing k-gram frequencies 
#' extracted from a training corpus.
#' @param lambda a length one numeric. Penalization in the
#' Stupid Back-off algorithm.
#' @param L a length one integer. Maximum number of next-word predictions
#' for a given input (top scoring predictions are retained).
#' @param filtered a character vector. Words to exclude from next-word 
#' predictions. The strings '<UNK>' and '<EOS>' are reserved keywords 
#' referring to the Unknown-Word and End-Of-Sentence tokens, respectively.
#' @return A \code{sbo_predictor} object for \code{train_predictor()}, a 
#' \code{sbo_predtable} object for \code{build_predtable()}.
#' @details These functions are used to train a text predictor using Stupid
#' Back-Off. The \code{sbo_predictor} data structure carries all information 
#' required for prediction in a compact and efficient (upon retrieval) way, 
#' by directly storing the top \code{L} next-word predictions for each
#' k-gram prefix observed in the training corpus.
#' 
#' The function \code{train_predictor()} is for interactive use. If the training
#' process is computationally heavy, one can obtain a "raw" version of the 
#' text predictor through \code{build_predtable()}, which can be safely 
#' saved out of memory (with e.g. \code{save()}). 
#' The resulting object (a \code{sbo_predtable}) can be restored
#' in another R session, and the corresponding \code{sbo_predictor} object
#' can be loaded rapidly using \code{load_predictor()} (see the example below).
#' 
#' The returned objects are a \code{sbo_predictor} and a \code{sbo_predtable} 
#' object, for \code{train_predictor} and \code{build_predtable} respectively.
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

#' @seealso \code{\link[sbo]{predict.sbo_predictor}}, 
#' \code{\link[sbo]{load_predictor}}
#'
#' @name sbo_predictions 
################################################################################
NULL
