context("summary.sbo_kgram_freqs")

test_that("returns invisibly the correct value", {
        capture_output({
                expect_invisible(summary(twitter_freqs))
                expect_identical(summary(twitter_freqs), twitter_freqs)
                },
                print = F)
})

test_that("Prints a title, an empty line and some text", {
        output <- capture_output_lines(summary(twitter_freqs), print = F)
        expect_gt(length(output), 2)
        expect_identical(output[1], "k-gram frequency table")
        expect_identical(output[2], "")
})
