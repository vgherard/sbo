context("print.sbo_predtable")

test_that("returns invisibly the correct value", {
        capture_output({
                expect_invisible(print(twitter_predtable))
                expect_identical(print(twitter_predtable), twitter_predtable)
                },
                print = F)
})

test_that("Prints simple title and an empty line followed by some text", {
        output <- capture_output_lines(print(twitter_predtable), print = F)
        expect_length(output, 3)
        expect_identical(output[1], "A Stupid Back-Off prediction table.")
        expect_identical(output[2], "")
})