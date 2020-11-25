## usethis namespace: start
#' @useDynLib sbo, .registration = TRUE
## usethis namespace: end
NULL
## usethis namespace: start
#' @importFrom Rcpp sourceCpp
## usethis namespace: end
NULL

#' @import dplyr
#' @importFrom rlang .data
#' @importFrom stats predict
#' @importFrom utils head tail
#' @importFrom graphics abline axis mtext
NULL

#' @description
#' Utilities for building and evaluating text prediction functions based on Stupid Back-Off N-gram models.
#' @keywords internal
#' @author Valerio Gherardi
#' @references 
#' The Stupid Back-Off smoothing method for N-gram models was introduced by
#' Brants et al., \url{https://www.aclweb.org/anthology/D07-1090/} (2007).
"_PACKAGE"