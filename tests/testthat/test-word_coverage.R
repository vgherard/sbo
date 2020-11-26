context("word_coverage")

# Dictionary (a, b) covering 70% of 'train' without EOS, 75% including EOS
train <- "a a a a b. b b c c d"
dict <- sbo_dictionary(corpus = train, max_size = 2, EOS = ".")
f <- 2 / 12 # fraction of EOS over total
c <- word_coverage(dict, train)

test_that("Correct result from dict", {
        expect_equal(as.numeric(c), c(f, 6 / 12, 9 / 12))
        expect_equal((as.numeric(c)[-1] - f) / (1 - f), c(4 / 10, 7 / 10))
})

test_that("Correct result from other constructors", {
        freqs <- kgram_freqs(train, 2, dict, EOS = ".")
        p <- sbo_predictor(freqs, L = 1)
        
        c_char <- word_coverage(c("a", "b"), train, EOS = ".")
        c_freqs <- word_coverage(freqs, train)
        c_p <- word_coverage(p, train)
        
        expect_identical(c, c_char)
        expect_identical(c_char, c_freqs)
        expect_identical(c_freqs, c_p)
})
