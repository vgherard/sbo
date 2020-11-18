# N.B. this implementation excludes EOS

#' @export
word_coverage <- function(object, corpus, ...) 
        UseMethod("word_coverage")

#' @export
word_coverage.character <- function(object, corpus, 
                                    .preprocess = identity, EOS = ".?!:;",
                                    ...){
        corpus_freqs <- get_word_freqs(corpus, .preprocess, EOS)
        rm_na <- function(x) {x[is.na(x)] <- 0; return(x)}
        corpus_freqs <- corpus_freqs %>% {. / sum(.)} %>% {.[object]} %>% rm_na
        corpus_freqs <- cumsum(corpus_freqs)
        names(corpus_freqs) <- object
        return(structure(corpus_freqs, class = "word_coverage"))
}

#' @export
word_coverage.sbo_kgram_freqs <- function(object, corpus, ...){
        dict <- attr(object, "dict")
        .preprocess <- attr(object, ".preprocess")
        EOS <- attr(object, "EOS")
        return(word_coverage(dict, corpus, .preprocess, EOS))
}

#' @export
print.word_coverage <- function(x, ...){
        cat("A 'word_coverage' object.\n\n")
        cat(paste0("Dictionary length: ", length(x), ".\n"))
        f <- format(100 * last(x), digits = 3)
        cat(paste0("Fraction of corpus covered by dictionary: ", f, "%.\n"))
        return(invisible(x))
}

#' @export
plot.word_coverage <- function(
        x, y, type = "l",
        xlim = c(0, length(x)), ylim = c(0, 1), 
        xticks = seq(from = 0, to = length(x), by = length(x) / 5),
        yticks = seq(from = 0, to = 1, by = 0.25),
        xlab = "Rank", ylab = "Covered fraction",
        title = "Cumulative corpus coverage fraction of dictionary",
        subtitle = "_default_",
        plot_asy = TRUE,
        ...)
{
        if (!missing(y)) warning("'y' argument ignored.")
        plot(x[], type = type, 
             xlim = xlim, ylim = ylim, xaxs = "i", xaxt = "n", yaxt = "n",
             xlab = xlab, ylab = ylab,
             ...)
        if (subtitle == "_default_") {
                subtitle <- paste0("Dictionary length: ", length(x), ". ")
                f <- format(100 * last(x), digits = 3)
                subtitle <- paste0(subtitle, 
                                   "Total covered fraction: ", f, "%.")
        }
        mtext(side = 3, line = 2, adj = 0.5, cex = 1.2, title)
        mtext(side = 3, line = 0.7, adj = 0.5, cex = 0.85, subtitle)
        if (plot_asy) abline(h = last(x), col = "red", lty = "dashed")
        axis(1, at = xticks, las = 1)
        axis(2, at = yticks, las = 1)
}
