context("Argument checking for kgram_freqs()")

test_that("error on non character corpus",{
        expect_error(kgram_freqs(corpus = 1:10, N = 2, dict = c("a")),
                     class = "sbo_domain_error")
})

test_that("error on non numeric N",{
        expect_error(kgram_freqs(corpus = "a b c d", N = "1", dict = c("a")),
                     class = "sbo_domain_error")
        expect_error(kgram_freqs(corpus = "a b c d", N = TRUE, dict = c("a")),
                     class = "sbo_domain_error")
})

test_that("error on N < 1",{
        expect_error(kgram_freqs(corpus = "a b c d", N = 0, dict = c("a")),
                     class = "sbo_domain_error")
})

test_that("error on numeric dict",{
        expect_error(kgram_freqs(corpus = "a b c d", N = 2, dict = 2),
                     class = "sbo_domain_error")
})

test_that("error on invalid dict",{
        expect_error(kgram_freqs(corpus = "a b c d", N = 2, dict = 2),
                     class = "sbo_domain_error")
})

test_that("error on non-function .preprocess",{
        expect_error(kgram_freqs(corpus = "a b c d", N = 2, dict = c("a", "b"),
                                 .preprocess = ""),
                     class = "sbo_domain_error")
})

test_that("error on non character EOS",{
        expect_error(kgram_freqs(corpus = "a b c d", N = 2, dict = c("a", "b"),
                                 EOS = 840),
                     class = "sbo_domain_error")
})

test_that("error on length(EOS) > 1",{
        expect_error(kgram_freqs(corpus = "a b c d", N = 2, dict = c("a", "b"),
                                 EOS = c(".", "?")),
                     class = "sbo_domain_error")
})

test_that("error on non character erase",{
        expect_error(kgram_freqs_fast(corpus = "a b c d", N = 2, 
                                      dict = c("a", "b"), erase = 1),
                     class = "sbo_domain_error")
})

test_that("error on length(erase) > 1",{
        expect_error(kgram_freqs_fast(corpus = "a b c d", N = 2, 
                                      dict = c("a", "b"), erase = c("a", "b")),
                     class = "sbo_domain_error")
})

test_that("error on non-logical lower_case",{
        expect_error(kgram_freqs_fast(corpus = "a b c d", N = 2, 
                                      dict = c("a", "b"), 
                                      lower_case = "yes"
                                      ),
                     class = "sbo_domain_error")
})

test_that("error on length(lower_case) > 1",{
        expect_error(kgram_freqs_fast(corpus = "a b c d", N = 2, 
                                      dict = c("a", "b"), 
                                      lower_case = c(TRUE, FALSE)
                                      ),
                     class = "sbo_domain_error"
                     )
})