context("sbo_dictionary")

test_that("output has correct structure",{
        expect_true(is_sbo_dictionary(sbo_dictionary("a a a a b b b c c d")))
})

test_that("empty input -> empty output",{
        expect_identical(character(0), as.character(sbo_dictionary("")))
})

test_that("Correct dict on simple input: all words",{
        dict <- sbo_dictionary("a a a a b b b c c d")
        expect_identical(c("a", "b", "c", "d"), as.character(dict))
})

test_that("Correct dict on simple input: max_size words",{
        dict <- sbo_dictionary("a a a a b b b c c d", max_size = 3)
        expect_identical(c("a", "b", "c"), as.character(dict))
})

test_that("Correct dict on simple input: cover 'target'",{
        dict1 <- sbo_dictionary("a a a a b b b c c d", target = 0.66)
        dict2 <- sbo_dictionary("a a a a b b b c c d", target = 0.85)
        expect_identical(c("a", "b"), as.character(dict1))
        expect_identical(c("a", "b", "c"), as.character(dict2))
})

test_that("coverage must be strictly greater than 'target'",{
        dict <- sbo_dictionary("a a a a b b b c c d", target = 0.7)
        expect_identical(c("a", "b", "c"), as.character(dict))
})

test_that(".preprocess does its job",{
        dict <- sbo_dictionary("a a a a b b b c c d @ $ *", 
                               .preprocess = preprocess)
        expect_identical(c("a", "b", "c", "d"), as.character(dict))
        expect_identical(preprocess, attr(dict, ".preprocess"))
})

test_that("EOS does its job",{
        EOS <- ".!?:;"
        dict <- sbo_dictionary("a. a! a? a... b; b: b. c c d.", EOS = EOS)
        expect_identical(c("a", "b", "c", "d"), as.character(dict))
        expect_identical(EOS, attr(dict, "EOS"))
})
