context("predict.sbo_predictor")

p <- sbo_predictor(twitter_predtable)

test_that("empty input works",{
        actual <- predict(p, "")

        expect_type(actual, "character")
        expect_length(actual, attr(p, "L"))
        expect_length(unique(actual), attr(p, "L"))
})

test_that("whitespace inputs work",{
        reference <- predict(p, "")
        variant1 <- predict(p, " ")
        variant2 <- predict(p, "     ")

        expect_identical(variant1, reference)
        expect_identical(variant2, reference)
})


test_that("blank spaces correctly managed",{
        reference <- predict(p, "i love")
        variant1 <- predict(p, "i love ")
        variant2 <- predict(p, " i love")
        variant3 <- predict(p, " i love ")
        variant4 <- predict(p, "   i love  ")

        expect_identical(variant1, reference)
        expect_identical(variant2, reference)
        expect_identical(variant3, reference)
        expect_identical(variant4, reference)
})

test_that("EOS tokens correctly managed",{
        reference <- predict(p, "i love")
        variant1 <- predict(p, ". i love ")
        variant2 <- predict(p, ".i love")
        variant3 <- predict(p, "a sentence ... i love ")

        expect_identical(variant1, reference)
        expect_identical(variant2, reference)
        expect_identical(variant3, reference)
})

test_that("vector input returns matrix",{
        input <- c("i love", "you love", "she loves", 
                   "we love", "you love", "they love")
        output <- predict(p, input)
        expect_type(output, "character")
        expect_identical(dim(output), c(6L, attr(p, "L")))
})

test_that("predicting from 'predtable' object throws an error",{
        expect_error(predict(twitter_predtable, "i love"))
})
