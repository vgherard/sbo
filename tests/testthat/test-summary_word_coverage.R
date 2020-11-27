context("summary.word_coverage")

c <- word_coverage(twitter_dict, twitter_test)
test_that("returns invisibly the correct value", {
        capture_output({
                expect_invisible(summary(c))
                expect_identical(summary(c), c)
                },
                print = F)
})

test_that("Prints a title, an empty line and some text", {
        output <- capture_output_lines(summary(c), print = F)
        expect_gt(length(c), 2)
        title <- "Word coverage fraction"
        expect_identical(output[1], title)
        expect_identical(output[2], "")
        expect_true(output[3] != "")
})

rm(c)