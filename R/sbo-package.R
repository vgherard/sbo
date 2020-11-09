## usethis namespace: start
#' @useDynLib sbo, .registration = TRUE
## usethis namespace: end
NULL
## usethis namespace: start
#' @importFrom Rcpp sourceCpp
## usethis namespace: end
NULL

#' @importFrom tibble tibble as_tibble
#' @importFrom dplyr 
#' across vars all_of any_of
#' row_number cur_column
#' arrange
#' select filter distinct slice_max
#' mutate mutate_all rename
#' group_by group_by_at ungroup 
#' bind_rows left_join anti_join
#' @importFrom magrittr %>% %<>%
#' @importFrom tidyr pivot_wider
#' @importFrom stats predict
#' @importFrom utils head tail object.size
#' @importFrom stringi stri_split_fixed
NULL

#' @description
#' Utilities for building and evaluating text prediction functions based on Stupid Back-Off N-gram models.
#' @keywords internal
#' @author Valerio Gherardi
#' @references 
#' The Stupid Back-Off smoothing method for N-gram models was introduced by
#' Brants et al., \url{https://www.aclweb.org/anthology/D07-1090/} (2007).
"_PACKAGE"