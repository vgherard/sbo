context("kgram_freqs_fast")

test_that("return value has the correct structure", {
        f <- kgram_freqs_fast(corpus = "some text",
                             N = 3,
                             dict = c("some", "text"),
                             erase = "",
                             lower_case = FALSE,
                             EOS = "")
        expect_true(is.list(f))
        expect_true(length(f) == 3)
        expect_true(all(
                c("N", "dict", ".preprocess", "EOS") %in% names(attributes(f))
        ))
        expect_true(is.integer(attr(f, "N")))
        expect_true(is.character(attr(f, "dict")))
        expect_true(is.character(attr(f, "EOS")))
        expect_true( is.function(attr(f, ".preprocess")) )
        expect_identical(f[[1]], as_tibble(f[[1]]))
})

test_that("input `N <= 0` produces error", {
        expect_error(kgram_freqs_fast(corpus = "some text",
                                     N = 0,
                                     dict = c("some", "text"),
                                     erase = "",
                                     lower_case = FALSE,
                                     EOS = "")
                     )
        expect_error(kgram_freqs_fast(corpus = "some text",
                                     N = -1,
                                     dict = c("some", "text"),
                                     erase = "",
                                     lower_case = FALSE,
                                     EOS = "")
        )
})

# Used in the following tests
# N.B: 0L, 3L and 4L represent <BOS>, <EOS> and <UNK> respectively.
expected_1grams <- tibble(w2 = c(1L, 2L, 3L, 4L),
                          n  = c(8L, 6L, 4L, 2L)
                          ) %>% arrange(w2)
expected_2grams <- tibble(
        w1 = c(0L, 0L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 4L, 4L),
        w2 = c(1L, 2L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L, 1L, 2L),
        n  = c(3L, 1L, 2L, 3L, 2L, 1L, 2L, 1L, 2L, 1L, 1L, 1L)
        ) %>% arrange(w1, w2)

test_that("correct 1-gram and 2-gram counts on simple input", {
        input <- c("a a b a", "a b b a", "a c b", "b c a a b")
        dict <- c("a", "b")

        freqs <- kgram_freqs_fast(corpus = input, N = 2, dict = dict,
                                      erase = "", lower_case = FALSE, EOS = "")
        actual_1grams <- arrange(freqs[[1]], w2)
        actual_2grams <- arrange(freqs[[2]], w1, w2)

        expect_identical(expected_1grams, actual_1grams)
        expect_identical(expected_2grams, actual_2grams)
})

test_that("correct 1-gram and 2-gram with some preprocessing", {
        input <- c("a A b A", "a B b a", "a C B", "b c A a b")
        dict <- c("a", "b")

        freqs <- kgram_freqs_fast(corpus = input, N = 2, dict = dict,
                                      erase = "", lower_case = TRUE, EOS = "")
        actual_1grams <- arrange(freqs[[1]], w2)
        actual_2grams <- arrange(freqs[[2]], w1, w2)

        expect_identical(expected_1grams, actual_1grams)
        expect_identical(expected_2grams, actual_2grams)
})

test_that("correct 1-gram and 2-gram counts with EOS token", {
        input <- c("/ a a b a / a b b a / a c b / b c a a b /")
        dict <- c("a", "b")

        freqs <- kgram_freqs_fast(corpus = input, N = 2, dict = dict,
                                      erase = "", lower_case = FALSE, EOS = "/")
        actual_1grams <- arrange(freqs[[1]], w2)
        actual_2grams <- arrange(freqs[[2]], w1, w2)

        expect_identical(expected_1grams, actual_1grams)
        expect_identical(expected_2grams, actual_2grams)
})

test_that("build dictionary on the fly", {
        input <- c("a a b a", "a b b a", "a c b", "b c a a b")
        
        freqs <- kgram_freqs_fast(corpus = input, N = 2, dict = max_size ~ 2,
                                      erase = "", lower_case = FALSE, EOS = "")
        actual_1grams <- arrange(freqs[[1]], w2)
        actual_2grams <- arrange(freqs[[2]], w1, w2)
        
        expect_identical(expected_1grams, actual_1grams)
        expect_identical(expected_2grams, actual_2grams)
})

test_that("Argument dict = Inf works", {
        input <- c("a a b a", "a b b a", "a c b", "b c a a b")
        freqsInf <- kgram_freqs_fast(corpus = input, N = 2, dict = max_size ~ Inf,
                                      erase = "", lower_case = FALSE, EOS = "")
        freqs3 <- kgram_freqs_fast(corpus = input, N = 2, dict = max_size ~ 3,
                                      erase = "", lower_case = FALSE, EOS = "")
        attr(freqs3, ".preprocess") <- attr(freqsInf, ".preprocess") 
        expect_equal(freqs3, freqsInf)
})

rm(expected_1grams, expected_2grams)

test_that("Error on 'dict' argument not character or numeric", {
        input <- c("a a b a", "a b b a", "a c b", "b c a a b")
        expect_error(kgram_freqs_fast(corpus = input, N = 2, dict = TRUE))
})

test_that("Error on 'dict' argument negative numeric", {
        input <- c("a a b a", "a b b a", "a c b", "b c a a b")
        expect_error(kgram_freqs_fast(corpus = input, N = 2, dict = max_size ~ -1))
})
