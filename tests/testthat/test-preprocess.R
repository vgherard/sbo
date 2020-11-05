context("preprocess")

test_that("empty_string_is_left_unchanged_with_defaults", {
        input <- ""
        expected <- ""
        actual <- preprocess(input)
        expect_identical(actual, expected)
})

test_that("default_erase_arg_kills_anything_not_word_or_space_or_punctuation", {
        input <- "###Colorless%%% gre&en ide@as$ sl&eep, fu**r*i+ou/s(ly)"
        expected <- "Colorless green ideas sleep furiously"
        actual <- preprocess(input, lower_case = FALSE)
        expect_identical(actual, expected)
})

test_that("erase argument works with basic regex's", {
        input <- "this is a sentence"
        actual <- c(preprocess(input, erase = "[[:space:]]"),
                    preprocess(input, erase = "."),
                    preprocess(input, erase = "^\\w"),
                    preprocess(input, erase = "[aeiou]")
                    )
        expected <- c("thisisasentence", "", "his is a sentence",
                      "ths s  sntnc"
                      )
        expect_identical(actual, expected)
})

test_that("lower_case_works", {
        input <- "CoLoRleSs greEn iDEaS slEEp fUrIoUSlY"
        expected <- "colorless green ideas sleep furiously"
        actual <- preprocess(input, lower_case = TRUE)
        expect_identical(actual, expected)
})

test_that("length_zero_in_length_zero_out", {
        input <- character(0)
        expected <- character(0)
        actual <- preprocess(input)
        expect_identical(actual, expected)
})

test_that("vector_input_works", {
        input <- c("CoLoRleSs greEn iDEaS slEEp fUrIoUSlY",
                   "###Colorless%%% gre&en ide@as$ sl&eep, fu**r*i+ou/s(ly)",
                   "colorless green ideas sleep furiously",
                   "this iS AnotHer sentence!"
                   )
        expected <- c(rep("colorless green ideas sleep furiously", 3),
                      "this is another sentence!"
                      )
        actual <- preprocess(input)
        expect_identical(actual, expected)
})
