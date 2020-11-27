context("print.sbo_dictionary")

c <- word_coverage(twitter_dict, twitter_test)

test_that("returns invisibly the correct value", {
        capture_output({
                expect_invisible(print(c))
                expect_identical(print(c), c)
                },
                print = F)
})

test_that("Prints simple title and an empty line followed by some text", {
        output <- capture_output_lines(print(c), print = F)
        expect_length(output, 3)
        expect_identical(output[1], "A 'word_coverage' object.")
        expect_identical(output[2], "")
})

rm(c)