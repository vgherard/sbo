context("consistency of predict methods")

p <- load_predictor(twitter_predtable)

test_that("empty input works",{
        input <- ""
        L <- attr(p, "L")
        from_freqs <- predict(twitter_freqs, input)$completion[1:L]
        from_preds <- predict(p, input)

        expect_identical(from_freqs, from_preds)
})

test_that("some input works",{
        input <- "i love"
        L <- attr(p, "L")
        from_freqs <- predict(twitter_freqs, input)$completion[1:L]
        from_preds <- predict(p, input)

        expect_identical(from_freqs, from_preds)
})
