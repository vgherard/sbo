context("comparing predict.sbo_kgram_freqs() and predict.sbo_predictor()")

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
                from_freqs <- predict(twitter_freqs, input)$completion[1:L]
                from_preds <- predict(p, input)
                expect_identical(from_freqs, from_preds)
        })
}
