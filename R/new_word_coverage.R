new_word_coverage <- function(wfreqs){
        stopifnot(is.numeric(wfreqs))
        structure(wfreqs, class = "word_coverage")
}