context("plot.word_coverage")

test_that("plot() produces no error", {
        c <- word_coverage(twitter_dict, twitter_test)
        expect_error(plot(c, include_EOS = FALSE), NA)
        expect_error(plot(c, include_EOS = TRUE), NA)
        expect_error(plot(c, show_limit = FALSE), NA)
})
