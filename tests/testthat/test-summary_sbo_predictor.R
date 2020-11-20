context("summary.sbo_predictor")

p <- sbo_predictor(twitter_predtable)

test_that("returns invisibly the correct value", {
        capture_output({
                expect_invisible(summary(p))
                expect_identical(summary(p), p)
                },
                print = F)
})

test_that("Prints a title, an empty line and some text", {
        output <- capture_output_lines(summary(p), print = F)
        expect_gt(length(output), 2)
        title <- "Next-word text predictor from Stupid Back-off N-gram model"
        expect_identical(output[1], title)
        expect_identical(output[2], "")
        expect_true(output[3] != "")
})

rm(p)
