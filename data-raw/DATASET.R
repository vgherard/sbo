library(sbo)

if (file.exists("data-raw/en_US.twitter.txt")) {
        # Import data raw data
        twitter <- readLines("data-raw/en_US.twitter.txt")
        
        # Sample 60k tweets
        set.seed(840)
        twitter <- sample(twitter, 6e4, replace = FALSE)
        
        # Remove non-ASCII characters
        twitter <- stringi::stri_trans_general(twitter, "latin-ascii")
        twitter <- iconv(twitter, "latin1", "ASCII", sub = "")
        
        # Make train/test split
        N_train <- 5e4
        twitter_train <- twitter[seq_len(N_train)]
        twitter_test <- twitter[-seq_len(N_train)]
        
        # Save data
        usethis::use_data(twitter_train, twitter_test, overwrite = TRUE)
} else {
        message("File 'data-raw/en_US.twitter.txt' not found. ",
                "To download it using the Kaggle API, ", 
                "run the makefile in the 'data-raw' directory."
                )
        message("Using 'sbo::twitter_train' for the following steps.")
}
        

train_control <- list(.preprocess = preprocess, EOS = ".?!:;")

twitter_dict <- do.call(
        sbo_dictionary,
        args = append(list(corpus = twitter_train, max_size = 1000), 
                      train_control
                      )
        )

twitter_freqs <- do.call(
        kgram_freqs,
        args = append(list(corpus = twitter_train, N = 3, dict = twitter_dict),
                      train_control
                      )
        )

twitter_predtable <- sbo_predtable(twitter_freqs)

usethis::use_data(twitter_dict, twitter_freqs, twitter_predtable, overwrite = T)