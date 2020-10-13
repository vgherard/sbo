context("consistency of predict methods")

test_that("empty input works",{
        input <- ""
        L <- twitter_preds$L
        from_freqs <- predict(twitter_freqs, input)$completion[1:L]
        from_preds <- predict(twitter_preds, input)

        expect_identical(from_freqs, from_preds)
})

test_that("some input works",{
        input <- "i love"
        L <- twitter_preds$L
        from_freqs <- predict(twitter_freqs, input)$completion[1:L]
        from_preds <- predict(twitter_preds, input)

        expect_identical(from_freqs, from_preds)
})
