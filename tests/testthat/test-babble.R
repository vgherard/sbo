context("Babble")

p <- sbo_predictor(twitter_predtable)

test_that("some text is generated with default input argument",{
        set.seed(840)
        bla <- babble(p)
        expect_true(is.character(bla))
        expect_length(bla, 1)
})

test_that("some text is generated for input = ''",{
        set.seed(840)
        bla <- babble(p, input = "")
        expect_true(is.character(bla))
        expect_length(bla, 1)
})

test_that("some text is generated for input = 'i love'",{
        set.seed(840)
        bla <- babble(p, input = "")
        expect_true(is.character(bla))
        expect_length(bla, 1)
})

test_that("informs with output when reaches maximum length",{
        set.seed(840)
        expect_true(grepl("\\[\\.\\.\\. reached maximum length \\.\\.\\.\\]$",
                          babble(p, n_max = 1L))
                    )
})

test_that("throws error on non character or NA_character_ input",{
        set.seed(840)
        expect_error(babble(p, input = 1))
        expect_error(babble(p, input = TRUE))
})

test_that("throws error on length != 1 input",{
        set.seed(840)
        expect_error(babble(p, input = character()))
        expect_error(babble(p, input = c("i love", "you love")))
})

test_that("throws error on length != 1 input",{
        set.seed(840)
        expect_error(babble(p, input = character()))
        expect_error(babble(p, input = c("i love", "you love")))
})

test_that("throws error on non-numeric n_max",{
        set.seed(840)
        expect_warning(expect_error(babble(p, n_max = "ciao")))
})

test_that("throws error on NA n_max",{
        set.seed(840)
        expect_error(babble(p, n_max = NA_integer_))
})

test_that("throws error on length != 1 n_max",{
        set.seed(840)
        expect_error(babble(p, n_max = double()))
        expect_error(babble(p, n_max = c(1,2)))
})

test_that("throws error on n_max < 1",{
        set.seed(840)
        expect_error(babble(p, n_max = 0))
})