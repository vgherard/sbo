context("Test aliases")

test_that("aliases are correctly assigned",{
        expect_identical(sbo::kgram_freqs, sbo_kgram_freqs)
        expect_identical(sbo::kgram_freqs_fast, sbo_kgram_freqs_fast)
        expect_identical(sbo::dictionary, sbo_dictionary)
        expect_identical(sbo::predtable, sbo_predtable)
        expect_identical(sbo::predictor, sbo_predictor)
})