context("print.sbo_predictor")

p <- sbo_predictor(twitter_predtable)

test_that("returns invisibly the correct value", {
        capture_output({
                expect_invisible(print(p))
                expect_identical(print(p), p)
                },
                print = F)
})

test_that("Prints simple title and an empty line followed by some text", {
        output <- capture_output_lines(print(p), print = F)
        expect_length(output, 3)
        expect_identical(output[1], "A Stupid Back-Off text predictor.")
        expect_identical(output[2], "")
})
