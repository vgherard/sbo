context("argcheck_sbo_dictionary")

test_that("error on non character corpus",{
        expect_error(sbo_dictionary(corpus = 1), class = "sbo_domain_error")
})

test_that("error on non numeric max_size", {
        expect_error(sbo_dictionary(corpus = "a b c", max_size = "a"),
                     class = "sbo_domain_error")
})

test_that("error on length(max_size) > 1", {
        expect_error(sbo_dictionary(corpus = "a b c", max_size = c(2, 3)),
                     class = "sbo_domain_error")
})

test_that("error on max_size < 0", {
        expect_error(sbo_dictionary(corpus = "a b c", max_size = -1),
                     class = "sbo_domain_error")
})

test_that("error on non numeric 'target'", {
        expect_error(sbo_dictionary(corpus = "a b c", target = "all"),
                     class = "sbo_domain_error")
})

test_that("error on 'length(target) > 1'", {
        expect_error(sbo_dictionary(corpus = "a b c", target = c(0.5, 0.75)),
                     class = "sbo_domain_error")
})

test_that("error on target < 0", {
        expect_error(sbo_dictionary(corpus = "a b c", target = -0.5),
                     class = "sbo_domain_error")
})

test_that("error on target > 1", {
        expect_error(sbo_dictionary(corpus = "a b c", target = 1.5),
                     class = "sbo_domain_error")
})

test_that("error on non-function .preprocess",{
        expect_error(sbo_dictionary(corpus = "a b c d", .preprocess = ""),
                     class = "sbo_domain_error")
})

test_that("error on non character EOS",{
        expect_error(sbo_dictionary(corpus = "a b c d", EOS = 840),
                     class = "sbo_domain_error")
})

test_that("error on length(EOS) > 1",{
        expect_error(sbo_dictionary(corpus = "a b c d", EOS = c(".", "?")),
                     class = "sbo_domain_error")
})