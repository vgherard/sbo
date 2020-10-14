context("tokenize_sentences")

test_that("empty string contains no sentences", {
        input <- ""
        expected <- character(0)
        actual <- tokenize_sentences(input)
        expect_identical(actual, expected)
})

test_that("length zero input contains no sentences", {
        input <- character(0)
        expected <- character(0)
        actual <- tokenize_sentences(input)
        expect_identical(actual, expected)
})

test_that("string without EOS tokens is a single sentence", {
        input <- "This string does not contain any EOS token"
        expected <- input
        actual <- tokenize_sentences(input)
        expect_identical(actual, expected)
})

test_that("sentences separated by a single EOS token are correctly tokenized", {
        input <-
        "This is sentence one. This is sentence two! This: sentence three?"
        expected <- c("This is sentence one", "This is sentence two", "This",
                      "sentence three")
        actual <- tokenize_sentences(input)
        expect_identical(actual, expected)
})

test_that("sentences separated by many EOS tokens are correctly tokenized", {
        input <-
                " ... This is sentence one !!! This is sentence two . . . This ...? sentence three !!! !!! !!! !!!"
        expected <- c("This is sentence one", "This is sentence two", "This",
                      "sentence three")
        actual <- tokenize_sentences(input)
        expect_identical(actual, expected)
})

test_that("text_in_different_vector_elements_belongs_to_different_sentences", {
        input <- c("This is a sentence",
                   "This is another sentence.",
                   "Here is a third sentence; here is a fourth"
                   )
        expected <- c("This is a sentence", "This is another sentence",
                      "Here is a third sentence", "here is a fourth")
        actual <- tokenize_sentences(input)
        expect_identical(actual, expected)
})

test_that("returns input if no EOS token is given", {
        input <- c("This: is a sentence.",
                   "These are sentences!",
                   "These sentences contain several common EOS tokens!"
                   )
        expected <- input
        actual <- tokenize_sentences(input, EOS = "")
        expect_identical(actual, expected)
})

test_that("customized EOS tokens works correctly", {
        input <- c("~ACGCTCTAGC~AGCTCT~","GGGAG~~-~~CGCGAT-TAGA")
        expected <- c("ACGCTCTAGC", "AGCTCT", "GGGAG", "CGCGAT", "TAGA")
        actual <- tokenize_sentences(input, EOS = "~-")
        expect_identical(actual, expected)
})
