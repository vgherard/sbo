context("predict.sbo_kgram_freqs")

test_that("empty input works",{
        expect_type(predict(twitter_freqs, ""), "list")
})

test_that("whitespace inputs work",{
        reference <- predict(twitter_freqs, "")
        variant1 <- predict(twitter_freqs, " ")
        variant2 <- predict(twitter_freqs, "     ")

        expect_identical(variant1, reference)
        expect_identical(variant2, reference)
})


test_that("blank spaces correctly managed",{
        reference <- predict(twitter_freqs, "i love")
        variant1 <- predict(twitter_freqs, "i love ")
        variant2 <- predict(twitter_freqs, " i love")
        variant3 <- predict(twitter_freqs, " i love ")
        variant4 <- predict(twitter_freqs, "   i love  ")

        expect_identical(variant1, reference)
        expect_identical(variant2, reference)
        expect_identical(variant3, reference)
        expect_identical(variant4, reference)
})

test_that("EOS tokens correctly managed",{
        reference <- predict(twitter_freqs, "i love")
        variant1 <- predict(twitter_freqs, ". i love ")
        variant2 <- predict(twitter_freqs, ".i love")
        variant3 <- predict(twitter_freqs, "a sentence ... i love ")

        expect_identical(variant1, reference)
        expect_identical(variant2, reference)
        expect_identical(variant3, reference)
})
