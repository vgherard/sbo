new_kgram_freqs <- function(freqs, N, dict, .preprocess, EOS) {
        stopifnot(is.list(freqs), is.integer(N), is_sbo_dictionary(dict), 
                  is.function(.preprocess), is.character(EOS))
        attributes(dict) <- NULL
        structure(freqs,
                  N = N, dict = dict, 
                  .preprocess = utils::removeSource(.preprocess), EOS = EOS,
                  class = "sbo_kgram_freqs"
                  ) # return
}
