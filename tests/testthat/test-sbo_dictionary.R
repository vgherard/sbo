context("sbo_dictionary")

test_that("output has correct structure",{
        expect_true(is_sbo_dictionary(sbo_dictionary("a b c b b b c d a")))
})
