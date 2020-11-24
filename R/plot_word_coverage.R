################################################################################
#' Plot method for word_coverage objects
#'
#' Plot cumulative corpus coverage fraction of a dictionary.
#'
#' @export
#'
#' @author Valerio Gherardi
#' @md
#'
#' @param x a \code{word_coverage} object.
#' @param include_EOS length one logical. Should End-Of-Sentence tokens be 
#' considered in the computation of coverage fraction?
#' @param show_limit length one logical. If \code{TRUE}, plots an horizontal
#' line corresponding to the total coverage fraction.
#' @param type what type of plot should be drawn, as detailed in \code{?plot}.
#' @param xlim length two numeric. Extremes of the x-range.
#' @param ylim length two numeric. Extremes of the y-range.
#' @param xticks numeric vector. position of the x-axis ticks.
#' @param yticks numeric vector. position of the y-axis ticks. 
#' @param xlab length one character. The x-axis label.
#' @param ylab length one character. The y-axis label.
#' @param title length one character. Plot title.
#' @param subtitle length one character. Plot subtitle; if "_default_", prints
#' dictionary length and total covered fraction.
#' @param ... further arguments passed to or from other methods.
#' @details This function generates nice plots of cumulative corpus coverage
#' fractions. The \code{x} coordinate in the resulting plot is the word rank in the
#' underlying dictionary; the \code{y} coordinate at 
#' \code{x} is the cumulative coverage fraction for \code{rank <= x}.
#' @examples
#' \donttest{
#' c <- word_coverage(twitter_dict, twitter_test)
#' plot(c)
#' }
plot.word_coverage <- function(
        x, include_EOS = FALSE, show_limit = TRUE, type = "l",
        xlim = c(0, length(x)), ylim = c(0, 1), 
        xticks = seq(from = 0, to = length(x), by = length(x) / 5),
        yticks = seq(from = 0, to = 1, by = 0.25),
        xlab = "Rank", ylab = "Covered fraction",
        title = "Cumulative corpus coverage fraction of dictionary",
        subtitle = "_default_",
        ...)
{
        if (include_EOS) {
                x <- x[-1]
        } else {
                x <- (x[-1] - x[[1]]) / (1 - x[[1]])
        }
        plot(x, type = type, 
             xlim = xlim, ylim = ylim, xaxs = "i", xaxt = "n", yaxt = "n",
             xlab = xlab, ylab = ylab, ...)
        if (subtitle == "_default_") {
                sub <- paste0("Dictionary length: ", length(x), ". ")
                f <- format(100 * last(x), digits = 3)
                sub <- paste0(sub, "Total covered fraction: ", f, "%")
        }
        mtext(side = 3, line = 2, adj = 0.5, cex = 1.2, title)
        mtext(side = 3, line = 0.7, adj = 0.5, cex = 0.85, sub)
        if (show_limit) abline(h = last(x), col = "red", lty = "dashed")
        axis(1, at = xticks, las = 1)
        axis(2, at = yticks, las = 1)
        return(invisible(NULL))
}