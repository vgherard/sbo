context("get_word_freqs")

test_that("word_freqs_in_empty_string", {
        string <- ""
        expected <- integer(0);
        names(expected) <- character(0)
        expect_identical(expected,
                     get_word_freqs(string, .preprocess = identity, EOS = "")
                     )
})

test_that("basic_frequencies", {
        string <- "A B C C A D A B C"
        expected <- c("A" = 3L, "B" = 2L, "C" = 3L, "D" = 1L)
        actual <- get_word_freqs(string, .preprocess = identity, EOS = "")
        expected <- expected[sort(names(expected))]
        actual <- actual[sort(names(actual))]
        expect_identical(expected, actual)
})

test_that("basic_frequencies_with_blank_space", {
        string <- "A B C C A      D  A     B C"
        expected <- c("A" = 3L, "B" = 2L, "C" = 3L, "D" = 1L)
        actual <- get_word_freqs(string, .preprocess = identity, EOS = "")
        expected <- expected[sort(names(expected))]
        actual <- actual[sort(names(actual))]
        expect_identical(expected, actual)
})

test_that("basic_frequencies_with_EOS_tokens", {
        string <- "A B... C!! C A. D! A B???!? ???!?!??! !? C"
        expected <- c("A" = 3L, "B" = 2L, "C" = 3L, "D" = 1L)
        actual <- get_word_freqs(string, .preprocess = identity, EOS = ".?!")
        expected <- expected[sort(names(expected))]
        actual <- actual[sort(names(actual))]
        expect_identical(expected, actual)
})

test_that("basic_frequencies_with_EOS_tokens_bis", {
        string <- "...A B B A !?!"
        expected <- c("A" = 2L, "B" = 2L)
        actual <- get_word_freqs(string, .preprocess = identity, EOS = ".?!")
        expected <- expected[sort(names(expected))]
        actual <- actual[sort(names(actual))]
        expect_identical(expected, actual)
})

test_that("preprocess_argument", {
        string <- "I never never NEVER thought I would ever think what I had never thought."
        expected <- c("i" = 3L, "never" = 4L, "thought" = 2L, "would" = 1L,
                      "ever" = 1L, "think" = 1L, "what" = 1L, "had" = 1L)
        actual <- get_word_freqs(string, .preprocess = tolower, EOS = ".?!")
        expected <- expected[sort(names(expected))]
        actual <- actual[sort(names(actual))]
        expect_identical(expected, actual)
})

test_that("vector_inputs", {
        string <- c("I never never NEVER", "thought I would ever think",
                    "what I had never thought.")
        expected <- c("i" = 3L, "never" = 4L, "thought" = 2L, "would" = 1L,
                      "ever" = 1L, "think" = 1L, "what" = 1L, "had" = 1L)
        actual <- get_word_freqs(string, .preprocess = tolower, EOS = ".?!")
        expected <- expected[sort(names(expected))]
        actual <- actual[sort(names(actual))]
        expect_identical(expected, actual)
})
