context("Stupid Back-Off algorithm: predict.sbo_kgram_freqs()")

test_that("Scores correctly assigned: 2-gram model predictions",{
        train <- c("a a b a", "a b b a", "a c b", "b c a a b")
        dict <- c("a", "b")
        lambda <- 0.4
        
        expected <- list(" "   = c("a"     = (lambda ^ 0) * (3 / 4), # From 2-g
                                   "b"     = (lambda ^ 0) * (1 / 4), # From 2-g
                                   "<EOS>" = (lambda ^ 1) * (4 / 20),# From 1-g
                                   "<UNK>" = (lambda ^ 1) * (2 / 20) # From 1-g
                                   ),
                         "a"   = c("a"     = (lambda ^ 0) * (2 / 8),
                                   "b"     = (lambda ^ 0) * (3 / 8),
                                   "<EOS>" = (lambda ^ 0) * (2 / 8),
                                   "<UNK>" = (lambda ^ 0) * (1 / 8)
                                  ),
                         "b"   = c("a"     = (lambda ^ 0) * (2 / 6),
                                   "b"     = (lambda ^ 0) * (1 / 6),
                                   "<EOS>" = (lambda ^ 0) * (2 / 6),
                                   "<UNK>" = (lambda ^ 0) * (1 / 6)
                                   ),
                         "x"   = c("a"     = (lambda ^ 0) * (1 / 2),
                                   "b"     = (lambda ^ 0) * (1 / 2),
                                   "<EOS>" = (lambda ^ 1) * (4 / 20),
                                   "<UNK>" = (lambda ^ 1) * (2 / 20)
                                   )
                         ) %>%
                lapply(function(x){
                        x <- x / sum(x)
                        completion <- names(x)
                        attributes(x) <- NULL
                        x <- tibble(completion = completion, probability = x)
                        x <- filter(x, completion != "<UNK>")
                        return(arrange(x, desc(probability)))
                })
        f <- kgram_freqs(corpus = train, N = 2, dict = dict,
                             .preprocess = identity, EOS = "")
        actual <- lapply(c(" ", "a", "b", "x"), 
                         function(input) predict(f, input, lambda = lambda))
        names(actual) <- names(expected)
        expect_equal(expected, actual)
})

test_that("Scores correctly assigned: 3-gram model predictions",{
        train <- c("a a b a", "a b b a", "a c b", "b c a a b")
        dict <- c("a", "b")
        lambda <- 0.4
        
        expected <- list(" "    = c("a"     = (lambda ^ 0) * (3 / 4), # From 3-g
                                    "b"     = (lambda ^ 0) * (1 / 4), # From 3-g
                                    "<EOS>" = (lambda ^ 2) * (4 / 20),# From 1-g
                                    "<UNK>" = (lambda ^ 2) * (2 / 20) # From 1-g
                                    ),
                         "a"   = c("a"     = (lambda ^ 0) * (1 / 3),
                                   "b"     = (lambda ^ 0) * (1 / 3),
                                   "<EOS>" = (lambda ^ 1) * (2 / 8),
                                   "<UNK>" = (lambda ^ 0) * (1 / 3)
                                   ),
                         "b"   = c("a"     = (lambda ^ 1) * (2 / 6),
                                   "b"     = (lambda ^ 1) * (1 / 6),
                                   "<EOS>" = (lambda ^ 1) * (2 / 6),
                                   "<UNK>" = (lambda ^ 0) * (1 / 1)
                                   ),
                         "x"   = c("a"     = (lambda ^ 1) * (1 / 2),
                                   "b"     = (lambda ^ 1) * (1 / 2),
                                   "<EOS>" = (lambda ^ 2) * (4 / 20),
                                   "<UNK>" = (lambda ^ 2) * (2 / 20)
        )
        ) %>%
                lapply(function(x){
                        x <- x / sum(x)
                        completion <- names(x)
                        attributes(x) <- NULL
                        x <- tibble(completion = completion, probability = x)
                        x <- filter(x, completion != "<UNK>")
                        return(arrange(x, desc(probability)))
                })
        f <- kgram_freqs(corpus = train, N = 3, dict = dict,
                         .preprocess = identity, EOS = "")
        actual <- lapply(c(" ", "a", "b", "x"), 
                         function(input) predict(f, input, lambda = lambda))
        names(actual) <- names(expected)
        expect_equal(expected, actual)
})
