context("sbo_predtable")

test_that("return value has the correct structure", {
        input <- c("a a b a", "a b b a", "a c b", "b c a a b")
        freqs <- kgram_freqs(input, N = 3, dict = c("a", "b", "c"))
        predtable <- sbo_predtable(freqs)
        
        expect_s3_class(predtable, c("sbo_predtable", "sbo_predictions"), T)
        expect_true(is.list(predtable))
        expect_true(length(predtable) == 3)
        expect_setequal(
                names(attributes(predtable)),
                c("N", "dict", "lambda", "L", ".preprocess", "EOS", "class")
        )
        expect_true(is.integer(attr(predtable, "N")))
        expect_true(is.character(attr(predtable, "dict")))
        expect_true(is.numeric(attr(predtable, "lambda")))
        expect_true(is.integer(attr(predtable, "L")))
        expect_true(is.character(attr(predtable, "EOS")))
        expect_true(is.function(attr(predtable, ".preprocess")))
})

test_that("different methods are consistent", {
        input <- c("a a b a", "a b b a", "a c b", "b c a a b")
        predtable_char <- sbo_predtable(input, N = 3, dict = c("a", "b", "c"))
        freqs <- kgram_freqs(input, N = 3, dict = c("a", "b", "c"))
        predtable_freqs <- sbo_predtable(freqs)
        expect_identical(predtable_char, predtable_freqs)
})



# Used in the following tests

input <- c("a a b a", "a b b a", "a c b", "b c a a b")
freqs <- kgram_freqs(input, N = 3, dict = c("a", "b", "c"))
expect_domain_error <- function(x) expect_error(x, class = "sbo_domain_error")

test_that("Errors on invalid lambda", {
        expect_domain_error(sbo_predtable(freqs, lambda = "Zero"))
        expect_domain_error(sbo_predtable(freqs, lambda = c(0.2, 0.4)))
        expect_domain_error(sbo_predtable(freqs, lambda = -0.4))
        expect_domain_error(sbo_predtable(freqs, lambda = 1.2))
})

test_that("Errors on invalid L", {
        expect_domain_error(sbo_predtable(freqs, L = "All"))
        expect_domain_error(sbo_predtable(freqs, L = c(1,2,3)))
        expect_domain_error(sbo_predtable(freqs, L = 0))
        expect_domain_error(sbo_predtable(freqs, L = 5)) # Too many predictions!
})

test_that("Errors on invalid filtered", {
        expect_domain_error(sbo_predtable(freqs, filtered = c(1,2,3)))
})

test_that("Errors on L_max == 0", {
        filtered = c("a", "b", "c", "d", "e", "<UNK>", "<EOS>")
        expect_domain_error(sbo_predtable(freqs, filtered = filtered))
})
