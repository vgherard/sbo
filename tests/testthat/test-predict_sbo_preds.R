context("predict.sbo_preds")

test_that("empty input works",{
        actual <- predict(twitter_preds, "")

        expect_type(actual, "character")
        expect_length(actual, twitter_preds$L)
        expect_length(unique(actual), twitter_preds$L)
})

test_that("whitespace inputs work",{
        reference <- predict(twitter_preds, "")
        variant1 <- predict(twitter_preds, " ")
        variant2 <- predict(twitter_preds, "     ")

        expect_identical(variant1, reference)
        expect_identical(variant2, reference)
})


test_that("blank spaces correctly managed",{
        reference <- predict(twitter_preds, "i love")
        variant1 <- predict(twitter_preds, "i love ")
        variant2 <- predict(twitter_preds, " i love")
        variant3 <- predict(twitter_preds, " i love ")
        variant4 <- predict(twitter_preds, "   i love  ")

        expect_identical(variant1, reference)
        expect_identical(variant2, reference)
        expect_identical(variant3, reference)
        expect_identical(variant4, reference)
})

test_that("EOS tokens correctly managed",{
        reference <- predict(twitter_preds, "i love")
        variant1 <- predict(twitter_preds, ". i love ")
        variant2 <- predict(twitter_preds, ".i love")
        variant3 <- predict(twitter_preds, "a sentence ... i love ")

        expect_identical(variant1, reference)
        expect_identical(variant2, reference)
        expect_identical(variant3, reference)
})
