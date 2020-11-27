context("print.sbo_dictionary")

test_that("returns invisibly the correct value", {
        capture_output({
                expect_invisible(print(twitter_dict))
                expect_identical(print(twitter_dict), twitter_dict)
                },
                print = F)
})

test_that("Prints simple title and an empty line followed by some text", {
        output <- capture_output_lines(print(twitter_dict), print = F)
        expect_length(output, 3)
        expect_identical(output[1], "A dictionary.")
        expect_identical(output[2], "")
})
