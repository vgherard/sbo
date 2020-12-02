context("comparing predict.sbo_kgram_freqs() and predict.sbo_predictor()")

test_that("predictions agree on simple example", {
        train <- paste(sample(letters, 10000, replace = T, prob = rnorm(26)^2), 
                       collapse = " ")
        dict <- sample(letters, 13)
        lambda <- 0.2
        L <- 1
        freqs <- kgram_freqs(corpus = train, N = 3, dict = dict)
        p <- sbo_predictor(object = train, N = 3, dict = dict, L = L, 
                           lambda = lambda)
        
        N_tests <- 20
        w1 <- sample(dict, N_tests, replace = T)
        w2 <- sample(dict, N_tests, replace = T) 
        for (input in paste(w1, w2)) {
                from_freqs <- predict(freqs, input, 
                                      lambda = lambda)$completion[1:L]
                from_preds <- predict(p, input)
                
                expect_identical(from_freqs, from_preds)
        }
        
})

# Variables used in the following tests
p <- sbo_predictor(twitter_predtable)
L <- attr(p, "L")

test_that("empty input works",{
        input <- ""
        from_freqs <- predict(twitter_freqs, input)$completion[1:L]
        from_preds <- predict(p, input)

        expect_identical(from_freqs, from_preds)
})

test_that("some input works",{
        input <- "i love"
        from_freqs <- predict(twitter_freqs, input)$completion[1:L]
        from_preds <- predict(p, input)

        expect_identical(from_freqs, from_preds)
})

dict <- attr(twitter_freqs, "dict")
inputs <- paste(sample(dict, 10), sample(dict, 10))
for (input in inputs) {
        test_that(paste0("Random input: ", input),{
                from_freqs <- predict(twitter_freqs, input, 
                                      lambda = 0.4)$completion[1:L]
                from_preds <- predict(p, input)
                expect_identical(from_freqs, from_preds)
        })
}

rm(p, L)