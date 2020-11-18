context("summary.sbo_predtable")

test_that("returns invisibly the correct value", {
        capture_output({
                expect_invisible(summary(twitter_predtable))
                expect_identical(summary(twitter_predtable), twitter_predtable)
                },
                print = F)
})

test_that("Prints a title, an empty line and some text", {
        output <- capture_output_lines(summary(twitter_predtable), print = F)
        expect_gt(length(output), 2)
        title <- "Next-word prediction table from Stupid Back-off N-gram model"
        expect_identical(output[1], title)
        expect_identical(output[2], "")
        expect_true(output[3] != "")
})