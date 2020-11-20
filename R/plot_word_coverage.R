#' @export
plot.word_coverage <- function(
        x, y, include_EOS = FALSE, show_limit = TRUE, type = "l",
        xlim = c(0, length(x)), ylim = c(0, 1), 
        xticks = seq(from = 0, to = length(x), by = length(x) / 5),
        yticks = seq(from = 0, to = 1, by = 0.25),
        xlab = "Rank", ylab = "Covered fraction",
        title = "Cumulative corpus coverage fraction of dictionary",
        subtitle = "_default_",
        ...)
{
        if (!missing(y)) warning("'y' argument ignored.")
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
}