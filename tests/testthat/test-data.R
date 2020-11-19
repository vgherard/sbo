context("Data is updated")

test_that("twitter_predtable == sbo_predtable(twitter_freqs)",{
        skip("Skip test for updated data")
        expect_identical(twitter_predtable, sbo_predtable(twitter_freqs))
})
