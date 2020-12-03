context("eval_sbo_predictor")

test_that("doesn't throw errors with twitter_test sample",{
        p <- sbo_predictor(twitter_predtable)
        
        expect_error(eval_sbo_predictor(p, twitter_test[1:100]), NA)
})

test_that("output has the correct structure",{
        n_test <- 100
        L <- 2
        p <- sbo_predictor(twitter_predtable)
        p_eval <- eval_sbo_predictor(p, twitter_test[1:100], L = L)
        expect_s3_class(p_eval, class(tibble()))
        expect_true(nrow(p_eval) == n_test)
        classes <- list(input = "character", 
                        true = "character", 
                        preds = "matrix", 
                        correct = "logical")
        expect_identical(lapply(p_eval, function(x) class(x)[[1]]), 
                         classes)
        expect_equal(dim(p_eval[["preds"]]), c(n_test, L))
})

test_that("correctly identifies correct prediction",{
        n_test <- 100
        p <- sbo_predictor(twitter_predtable)
        p_eval <- eval_sbo_predictor(p, twitter_test[1:n_test], L = 2)
        correct <- logical(n_test)
        for (i in seq_len(n_test)) {
                correct[[i]] <- p_eval[["true"]][[i]] %in% p_eval[["preds"]][i, ]
                
        }
        expect_identical(correct, p_eval[["correct"]])
})

test_that("error on invalid 'model'",{
        expect_error(eval_sbo_predictor(twitter_freqs, test = "i love"), 
                     class = "sbo_domain_error")
})

test_that("error on invalid 'test'",{
        p <- sbo_predictor("a b c d", N = 2, dict = c("a", "b"))
        expect_error(eval_sbo_predictor(p, test = 1:10), 
                     class = "sbo_domain_error")
        expect_error(eval_sbo_predictor(p, test = character(0)), 
                     class = "sbo_domain_error")
})

test_that("errors on invalid 'L'",{
        p <- sbo_predictor("a b c d", N = 2, dict = c("a", "b"))
        expect_error(eval_sbo_predictor(p, test = "d c a b", L = TRUE), 
                     class = "sbo_domain_error")
        expect_error(eval_sbo_predictor(p, test = "d c a b", L = c(1,2)), 
                     class = "sbo_domain_error")
        expect_error(eval_sbo_predictor(p, test = "d c a b", L = 0), 
                     class = "sbo_domain_error")
})

test_that("no error on no sentences",{
        p <- sbo_predictor("a b c d", N = 2, dict = c("a", "b"), EOS = ".")
        expect_error(eval_sbo_predictor(p, test = ""), NA)
})

test_that("no error on empty sentence only",{
        p <- sbo_predictor("a b c d", N = 2, dict = c("a", "b"), EOS = "")
        expect_error(eval_sbo_predictor(p, test = ""), NA)
})