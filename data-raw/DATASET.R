## code to prepare `DATASET` dataset goes here

library(sbo)

train_control <- list(.preprocess = preprocess, EOS = ".?!:;")

twitter_dict <- do.call(
        function(...) 
                sbo_dictionary(corpus = twitter_train, max_size = 1000, ...),
        args = train_control
        )
twitter_freqs <- do.call(
        function(...) 
                kgram_freqs(corpus = twitter_train, N = 3, dict = twitter_dict,
                            ...),
        args = train_control
        )
twitter_predtable <- sbo_predtable(twitter_freqs)

usethis::use_data(twitter_dict, twitter_freqs, twitter_predtable, overwrite = T)
