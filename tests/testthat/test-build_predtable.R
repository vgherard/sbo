context("build_predtable")

test_that("return value has the correct structure", {
        input <- c("a a b a", "a b b a", "a c b", "b c a a b")
        freqs <- get_kgram_freqs(input, N = 3, dict = c("a", "b", "c"))
        predtable <- build_predtable(freqs)
        
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