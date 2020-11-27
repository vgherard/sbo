context("summary.sbo_dictionary")

test_that("returns invisibly the correct value", {
        capture_output({
                expect_invisible(summary(twitter_dict))
                expect_identical(summary(twitter_dict), twitter_dict)
                },
                print = F)
})

test_that("Prints a title, an empty line and some text", {
        output <- capture_output_lines(summary(twitter_dict), print = F)
        expect_gt(length(output), 2)
        title <- "Dictionary"
        expect_identical(output[1], title)
        expect_identical(output[2], "")
        expect_true(output[3] != "")
})
