## code to prepare `DATASET` dataset goes here

twitter_dict <- names(get_word_freqs(twitter_train))[1:1000]
twitter_freqs <- get_kgram_freqs(twitter_train, N = 3, twitter_dict)
twitter_preds <- build_sbo_preds(twitter_freqs)

usethis::use_data(twitter_dict, twitter_freqs, twitter_preds, overwrite = TRUE)
