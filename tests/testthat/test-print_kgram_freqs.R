context("print.sbo_kgram_freqs")

test_that("returns invisibly the correct value", {
        capture_output({
                expect_invisible(print(twitter_freqs))
                expect_identical(print(twitter_freqs), twitter_freqs)
                },
                print = F)
})

test_that("Prints simple title and an empty line followed by some text", {
        output <- capture_output_lines(print(twitter_freqs), print = F)
        expect_length(output, 3)
        expect_identical(output[1], "A k-gram frequency table.")
        expect_identical(output[2], "")
        expect_true(output[3] != "")
})
