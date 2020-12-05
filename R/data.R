#' Twitter training set
#'
#' @source \url{https://www.kaggle.com/crmercado/tweets-blogs-news-swiftkey-dataset-4million}
#' @format A collection of 50'000 Twitter posts in English.
#' @seealso \code{\link[sbo]{twitter_test}}, \code{\link[sbo]{twitter_dict}},
#' \code{\link[sbo]{twitter_freqs}}, \code{\link[sbo]{twitter_predtable}}
#' @examples
#' head(twitter_train)
"twitter_train"

#' Twitter test set
#'
#' @source \url{https://www.kaggle.com/crmercado/tweets-blogs-news-swiftkey-dataset-4million}
#' @format A collection of 10'000 Twitter posts in English.
#' @seealso \code{\link[sbo]{twitter_train}}
#' @examples
#' head(twitter_test)
"twitter_test"

#' Top 1000 dictionary from Twitter training set
#'
#' @md
#' @format A character vector. Contains the 1000 most frequent words from
#' the example training set \code{\link[sbo]{twitter_train}}, sorted by word
#' rank.
#' @examples
#' head(twitter_dict, 10)
#' @seealso \code{\link[sbo]{twitter_train}}
"twitter_dict"



#' k-gram frequencies from Twitter training set
#'
#' @md
#' @format A \code{sbo_kgram_freqs} object. Contains k-gram frequencies from
#' the example training set \code{\link[sbo]{twitter_train}}.
#' @seealso \code{\link[sbo]{twitter_train}}
"twitter_freqs"


#' Next-word prediction tables from 3-gram model trained on Twitter training
#' set
#' @md
#' @format A \code{sbo_predtable} object. Contains prediction tables of a 3-gram
#' Stupid Back-off model trained on the example training set
#' \code{\link[sbo]{twitter_train}}.
#' @seealso \code{\link[sbo]{twitter_train}}
"twitter_predtable"
